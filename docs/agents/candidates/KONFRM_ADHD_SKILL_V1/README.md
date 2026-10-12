# ADHD SKILL — KONFRM Candidate Snapshot (Draft, NOT INSTALLED)

**Status:** SAFE STAGING ONLY · **Created:** 2026-10-08 · **Target:** Future process-overlay integration **after PR #105 is reconciled**.

This directory durably stores the **exact 20-file ADHD SKILL v1 candidate package**, pending independent review and formal install. It does **not** register or activate a skill and does **not** modify the existing KONFRM domain brains, application code, APIs, database, worktrees or branch rules.

## Why this PR exists
To prevent loss of the candidate package if the ChatGPT conversation changes, while keeping **PR #105 the only active implementation priority**. **Do not merge this staging PR as-is.** Convert the snapshot into reviewable source files and integrate only after the current work is safely reconciled.

## Snapshot provenance and integrity
- Original ZIP: KONFRM_ADHD_SKILL_V1.zip, 20 UTF-8 source files, 51,823 unpacked bytes.
- The candidate content is stored as a **Brotli-compressed tar archive**, Base64-encoded and split across the four ordered `payload.partNN.txt` files. These are archival transport pieces, **not executable code**.
- SHA-256 of the reconstructed **compressed archive**, before decompressing:
  `2c6f8289e238e525769aede04cffc1a4bec8cef7ac293e791788d105bd08e633`.
- Confirmed before staging: ZIP integrity PASS, focus validator PASS, 11/11 local deterministic file-level tests PASS.
- **Not confirmed:** Antigravity runtime discovery, canonical router/manifest registration, production behavior, or live state.

## Restore and audit on a local review machine (Node.js 20+; no external dependencies)

From inside this directory:

```sh
node -e "const f=require('node:fs'),c=require('node:crypto'),z=require('node:zlib');const s=['01','02','03','04'].map(i=>f.readFileSync('payload.part'+i+'.txt','utf8').trim()).join('');const b=Buffer.from(s,'base64');const h=c.createHash('sha256').update(b).digest('hex');if(h!=='2c6f8289e238e525769aede04cffc1a4bec8cef7ac293e791788d105bd08e633')throw Error('Archive SHA-256 mismatch');f.writeFileSync('bundle.tar',z.brotliDecompressSync(b));console.log('VERIFIED BUNDLE: SHA-256 OK');"
mkdir -p unpacked
tar -xf bundle.tar -C unpacked
cd unpacked
node scripts/check-konfrm-focus.mjs
node scripts/test-konfrm-focus.mjs
```

Do NOT copy the files into active repository paths without the review gate below. The unpacked source includes `.agents/skills/konfrm-adhd/SKILL.md`, six reference modules, `docs/focus/` data, validator/tests, and human-readable installation/research/acceptance documentation.

## Merge-readiness gate (not satisfied by this snapshot)
1. Review all unpacked files, license/provenance, bootstrap decisions and stale state. GitHub HEAD and local Antigravity state must be checked separately. An archived bootstrap snapshot is **not live evidence**.
2. Reconcile PR #105 safely; never overwrite its worktree, unpushed files or HEAD.
3. Expand into proper, individually diff-reviewable paths on this branch. Align the integration protocol with actual state. Register a **cross-cutting process overlay**, NOT an eighth domain brain, using existing router and manifest contracts. Keep it opt-in/bounded; avoid persistent unbounded context.
4. Run all local + CI tests and negative controls. Demonstrate novel-idea capture, deduplication, founder approval, prerequisite blocks and interruption recovery with Antigravity.
5. Independent Bridge review and explicit Founder approval **before** marking ready or merging. Do not change financial/product Canon, production code, CI protection, deploy, or secret handling.

**KEEP DRAFT. DO NOT MERGE. NO AUTO-INSTALL.**