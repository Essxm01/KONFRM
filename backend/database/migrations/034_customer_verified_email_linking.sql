-- CUSTOMER AUTH V2 — VERIFIED EMAIL LINKING
-- Migration: 034_customer_verified_email_linking.sql
--
-- Founder-approved product rule:
--   An authenticated Customer can add and cryptographically verify an Email login
--   identifier to their EXISTING canonical account (user_id).
--
-- Invariants:
--   1. auth_challenges.intent expands to ('LOGIN', 'CREATE_ACCOUNT', 'LINK_IDENTIFIER').
--   2. A LINK_IDENTIFIER challenge MUST be bound to one authenticated Customer user_id
--      via the explicit subject_user_id column. LOGIN/CREATE_ACCOUNT must NOT carry subject_user_id.
--   3. One human Customer = one canonical public.users.id.
--   4. public.user_identifiers maintains uniqueness on (identifier_type, normalized_value)
--      AND on (user_id, identifier_type) [max 1 PHONE and max 1 EMAIL identifier per user].
--   5. public.users.email is maintained as a compatibility mirror of the verified canonical Email.
--   6. ADD-ONLY: If the user already has a different EMAIL identifier, linking fails closed.
--      No silent transfer, no email replacement in add flow, no account merge.
--   7. If the verified Email belongs to another account, linking fails closed with
--      IDENTIFIER_ALREADY_EXISTS.
--   8. The link operation is atomic via konfrm_link_verified_email_identifier_v1(),
--      serialized via subject user row lock (FOR UPDATE) followed by transactional email advisory lock.
--   9. Challenge is consumed atomically; replay is rejected.
--   10. Preflight check prevents applying migration if historical duplicate (user_id, identifier_type) exist.

BEGIN;

-- 1. Expand auth_challenges intent constraint to include LINK_IDENTIFIER (fail-closed, no exception swallowing)
ALTER TABLE public.auth_challenges DROP CONSTRAINT IF EXISTS auth_challenges_intent_check;
ALTER TABLE public.auth_challenges ADD CONSTRAINT auth_challenges_intent_check
  CHECK (intent IN ('LOGIN', 'CREATE_ACCOUNT', 'LINK_IDENTIFIER'));

-- 2. Add subject_user_id column bound to public.users
ALTER TABLE public.auth_challenges
  ADD COLUMN IF NOT EXISTS subject_user_id UUID REFERENCES public.users(id) ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_auth_challenges_subject_user_id
  ON public.auth_challenges(subject_user_id);

COMMENT ON COLUMN public.auth_challenges.subject_user_id IS
  'Bound authenticated Customer user_id for LINK_IDENTIFIER challenges; NULL for unauthenticated LOGIN/CREATE_ACCOUNT.';

-- 3. Enforce that LINK_IDENTIFIER challenges require subject_user_id, and LOGIN/CREATE_ACCOUNT must NOT have subject_user_id
ALTER TABLE public.auth_challenges DROP CONSTRAINT IF EXISTS chk_auth_challenges_subject_user_id;
ALTER TABLE public.auth_challenges ADD CONSTRAINT chk_auth_challenges_subject_user_id
  CHECK (
    (intent = 'LINK_IDENTIFIER' AND subject_user_id IS NOT NULL)
    OR
    (intent IN ('LOGIN', 'CREATE_ACCOUNT') AND subject_user_id IS NULL)
  );

-- 4. Preflight duplicate check before adding unique index on (user_id, identifier_type)
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM public.user_identifiers
    GROUP BY user_id, identifier_type
    HAVING COUNT(*) > 1
  ) THEN
    RAISE EXCEPTION 'CANNOT_APPLY_MIGRATION_034: Duplicate user_id and identifier_type found in public.user_identifiers';
  END IF;
END $$;

-- 5. Enforce at most one identifier per type per user
CREATE UNIQUE INDEX IF NOT EXISTS uq_user_identifiers_user_type
  ON public.user_identifiers(user_id, identifier_type);

-- 6. Atomic Email Link Function (Add-Only, Strict Invariants, User Lock -> Email Lock)
CREATE OR REPLACE FUNCTION public.konfrm_link_verified_email_identifier_v1(
  p_challenge_id UUID,
  p_subject_user_id UUID
)
RETURNS TABLE (
  success BOOLEAN,
  error_code VARCHAR(100),
  user_id UUID,
  email VARCHAR(255),
  verified_at TIMESTAMPTZ,
  already_linked BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
#variable_conflict use_column
DECLARE
  v_challenge public.auth_challenges%ROWTYPE;
  v_email VARCHAR(255);
  v_current_email_id UUID;
  v_current_email_val VARCHAR(255);
  v_current_verified_at TIMESTAMPTZ;
  v_existing_id UUID;
  v_existing_user_id UUID;
  v_legacy_conflict UUID;
  v_now TIMESTAMPTZ := NOW();
BEGIN
  -- 1. Validate inputs
  IF p_challenge_id IS NULL THEN
    RETURN QUERY SELECT FALSE, 'INVALID_CHALLENGE_ID'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  IF p_subject_user_id IS NULL THEN
    RETURN QUERY SELECT FALSE, 'UNAUTHORIZED_SUBJECT'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  -- 2. Concurrency Lock 1: Lock subject user row in public.users to serialize user operations
  PERFORM 1
  FROM public.users
  WHERE id = p_subject_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN QUERY SELECT FALSE, 'USER_NOT_FOUND'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  -- 3. Lock & load challenge with FOR UPDATE
  SELECT * INTO v_challenge
  FROM public.auth_challenges
  WHERE id = p_challenge_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN QUERY SELECT FALSE, 'CHALLENGE_NOT_FOUND'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  -- 4. Verify intent and method
  IF v_challenge.intent <> 'LINK_IDENTIFIER' OR v_challenge.method <> 'EMAIL' THEN
    RETURN QUERY SELECT FALSE, 'INVALID_LINK_CHALLENGE'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  -- 5. Verify subject binding
  IF v_challenge.subject_user_id IS NULL OR v_challenge.subject_user_id <> p_subject_user_id THEN
    RETURN QUERY SELECT FALSE, 'CHALLENGE_SUBJECT_MISMATCH'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  -- 6. Verify challenge status & validity
  IF v_challenge.status = 'CONSUMED' THEN
    RETURN QUERY SELECT FALSE, 'CHALLENGE_ALREADY_CONSUMED'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  IF v_challenge.status = 'CANCELLED' THEN
    RETURN QUERY SELECT FALSE, 'CHALLENGE_CANCELLED'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  IF v_challenge.status = 'LOCKED' THEN
    RETURN QUERY SELECT FALSE, 'CHALLENGE_LOCKED'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  IF v_challenge.status <> 'VERIFIED' THEN
    RETURN QUERY SELECT FALSE, 'CHALLENGE_NOT_VERIFIED'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  IF v_challenge.challenge_expires_at < v_now THEN
    RETURN QUERY SELECT FALSE, 'CHALLENGE_EXPIRED'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  -- 7. Normalize email from challenge authoritative record
  v_email := BTRIM(v_challenge.normalized_value);
  IF v_email = '' OR v_email IS NULL THEN
    RETURN QUERY SELECT FALSE, 'INVALID_EMAIL'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  -- 8. Concurrency Lock 2: Transactional Advisory Lock on normalized email to serialize cross-user attempts
  PERFORM pg_advisory_xact_lock(hashtextextended('KONFRM:EMAIL:' || v_email, 0));

  -- 9. Inspect current subject user's existing EMAIL identifier (Add-Only enforcement)
  SELECT ui.id, ui.normalized_value, ui.verified_at
  INTO v_current_email_id, v_current_email_val, v_current_verified_at
  FROM public.user_identifiers ui
  WHERE ui.user_id = p_subject_user_id
    AND ui.identifier_type = 'EMAIL'
  LIMIT 1;

  IF v_current_email_id IS NOT NULL THEN
    IF v_current_email_val <> v_email THEN
      -- CASE C & E: User already has a DIFFERENT EMAIL identifier (verified or unverified).
      -- FAIL CLOSED! Add-only flow does NOT allow replacing an existing email identifier.
      RETURN QUERY SELECT FALSE, 'IDENTIFIER_ALREADY_LINKED'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
      RETURN;
    ELSE
      -- Same email value exists on current user:
      IF v_current_verified_at IS NOT NULL THEN
        -- CASE B: Current user already has VERIFIED EMAIL with SAME value: idempotent success
        UPDATE public.users
        SET email = v_email, updated_at = v_now
        WHERE id = p_subject_user_id AND (email IS NULL OR email <> v_email);

        UPDATE public.auth_challenges
        SET status = 'CONSUMED', consumed_at = v_now, updated_at = v_now
        WHERE id = p_challenge_id;

        RETURN QUERY SELECT TRUE, NULL::VARCHAR(100), p_subject_user_id, v_email, v_current_verified_at, TRUE;
        RETURN;
      ELSE
        -- CASE D: Current user has UNVERIFIED EMAIL with SAME value: promote to verified
        UPDATE public.user_identifiers
        SET verified_at = v_now, updated_at = v_now
        WHERE id = v_current_email_id;

        UPDATE public.users
        SET email = v_email, updated_at = v_now
        WHERE id = p_subject_user_id;

        UPDATE public.auth_challenges
        SET status = 'CONSUMED', consumed_at = v_now, updated_at = v_now
        WHERE id = p_challenge_id;

        RETURN QUERY SELECT TRUE, NULL::VARCHAR(100), p_subject_user_id, v_email, v_now, FALSE;
        RETURN;
      END IF;
    END IF;
  END IF;

  -- 10. CASE A: Current user has NO email identifier. Check collisions with other users.
  -- 10a. Check public.user_identifiers for collisions with ANOTHER user
  SELECT ui.id, ui.user_id INTO v_existing_id, v_existing_user_id
  FROM public.user_identifiers ui
  WHERE ui.identifier_type = 'EMAIL'
    AND ui.normalized_value = v_email
  LIMIT 1;

  IF v_existing_user_id IS NOT NULL THEN
    IF v_existing_user_id = p_subject_user_id THEN
      -- Defensive: already linked to current user
      UPDATE public.users
      SET email = v_email, updated_at = v_now
      WHERE id = p_subject_user_id AND (email IS NULL OR email <> v_email);

      UPDATE public.auth_challenges
      SET status = 'CONSUMED', consumed_at = v_now, updated_at = v_now
      WHERE id = p_challenge_id;

      RETURN QUERY SELECT TRUE, NULL::VARCHAR(100), p_subject_user_id, v_email, v_now, TRUE;
      RETURN;
    ELSE
      -- Owned by ANOTHER user: FAIL CLOSED!
      RETURN QUERY SELECT FALSE, 'IDENTIFIER_ALREADY_EXISTS'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
      RETURN;
    END IF;
  END IF;

  -- 10b. Check legacy public.users.email for conflict with ANOTHER user
  SELECT u.id INTO v_legacy_conflict
  FROM public.users u
  WHERE u.email = v_email
    AND u.id <> p_subject_user_id
  LIMIT 1;

  IF v_legacy_conflict IS NOT NULL THEN
    -- Another user holds this email in legacy users table: FAIL CLOSED!
    RETURN QUERY SELECT FALSE, 'IDENTIFIER_ALREADY_EXISTS'::VARCHAR(100), NULL::UUID, NULL::VARCHAR(255), NULL::TIMESTAMPTZ, FALSE;
    RETURN;
  END IF;

  -- 11. Insert brand new verified EMAIL identifier for current user
  INSERT INTO public.user_identifiers (
    id,
    user_id,
    identifier_type,
    normalized_value,
    verified_at,
    created_at,
    updated_at
  ) VALUES (
    gen_random_uuid(),
    p_subject_user_id,
    'EMAIL',
    v_email,
    v_now,
    v_now,
    v_now
  );

  -- 12. Update public.users.email compatibility mirror
  UPDATE public.users
  SET email = v_email,
      updated_at = v_now
  WHERE id = p_subject_user_id;

  -- 13. Atomically consume the link challenge
  UPDATE public.auth_challenges
  SET status = 'CONSUMED',
      consumed_at = v_now,
      updated_at = v_now
  WHERE id = p_challenge_id;

  -- 14. Return success
  RETURN QUERY SELECT TRUE, NULL::VARCHAR(100), p_subject_user_id, v_email, v_now, FALSE;
END;
$$;

REVOKE ALL ON FUNCTION public.konfrm_link_verified_email_identifier_v1(UUID, UUID) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.konfrm_link_verified_email_identifier_v1(UUID, UUID) TO service_role;

-- 7. Register migration in schema_migrations
INSERT INTO public.schema_migrations (version)
VALUES ('034_customer_verified_email_linking.sql')
ON CONFLICT (version) DO NOTHING;

COMMIT;
