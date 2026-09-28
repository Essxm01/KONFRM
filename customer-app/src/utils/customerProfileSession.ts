import { getApiUrl } from './api';
import { mergeCustomerProfile } from './customerFavorites';

export type CustomerFetch = (input: RequestInfo | URL, init?: RequestInit) => Promise<Response>;
export type GetUrlFn = (path: string) => string;

/** A protected Customer profile read was rejected by the canonical session (401/403). */
export class CustomerProfileUnauthorizedError extends Error {
  constructor(message = 'Customer profile session expired') {
    super(message);
    this.name = 'CustomerProfileUnauthorizedError';
  }
}

/**
 * The canonical profile payload failed identity validation: an authenticated
 * Customer must carry at least one canonical verified PHONE or EMAIL identifier.
 */
export class CustomerProfileIdentityIntegrityError extends Error {
  constructor(message = 'Customer profile identity integrity failure') {
    super(message);
    this.name = 'CustomerProfileIdentityIntegrityError';
  }
}

/**
 * Canonical Screen 17/18 profile loader. Classification is fail-closed:
 * - 401/403        -> CustomerProfileUnauthorizedError
 * - invalid payload/identity -> CustomerProfileIdentityIntegrityError
 * - network / other HTTP    -> generic Error (truthful retryable failure)
 */
export async function fetchCanonicalCustomerProfile(
  token: string,
  fetchFn: CustomerFetch = fetch,
  getUrl: GetUrlFn = getApiUrl
): Promise<ReturnType<typeof mergeCustomerProfile>> {
  if (!token) throw new Error('CUSTOMER_TOKEN_REQUIRED');
  let res: Response;
  try {
    res = await fetchFn(getUrl('/customer/profile'), {
      headers: { Authorization: `Bearer ${token}` },
    });
  } catch (err: any) {
    throw new Error(`FETCH_CUSTOMER_PROFILE_NETWORK_ERROR: ${err?.message || String(err)}`);
  }
  if (res.status === 401 || res.status === 403) throw new CustomerProfileUnauthorizedError();
  if (!res.ok) throw new Error(`FETCH_CUSTOMER_PROFILE_FAILED: HTTP ${res.status}`);
  const json = await res.json().catch(() => null);
  if (!json || !json.success || !json.data) throw new Error('FETCH_CUSTOMER_PROFILE_MALFORMED');
  try {
    return mergeCustomerProfile(json.data);
  } catch {
    throw new CustomerProfileIdentityIntegrityError();
  }
}

/**
 * The only phone value a canonical profile may contribute to the legacy
 * `sola_customer_phone` display key. A canonical `phoneNumber === null` must
 * explicitly clear any previously stored phone (cross-account privacy).
 */
export function canonicalDisplayPhoneFromProfile(
  profile: { phoneNumber?: string | null } | null | undefined
): string | null {
  const phone = profile?.phoneNumber;
  return typeof phone === 'string' && phone.trim() !== '' ? phone.trim() : null;
}
