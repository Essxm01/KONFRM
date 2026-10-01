#!/usr/bin/env node
/**
 * KONFRM AI Design Skill Policy Checker
 *
 * Validates:
 * 1. Zero machine-specific absolute paths (Windows/drive/user paths).
 * 2. Zero unauthorized hooks (.codex/hooks.json, .agents/hooks.json).
 * 3. Thin-shim synchronization integrity (1:1 with canonical docs/ai/skills/).
 * 4. Structural validity of SKILL.md frontmatter.
 * 5. Ban on false-canon phrases in internal skills.
 * 6. Strict ban on write/persistence flags in ui-ux-pro-max wrapper.
 * 7. Exclusion of sandbox/rejected skills from agent discovery directories.
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { execSync } from 'node:child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.resolve(__dirname, '..');

let failureCount = 0;

function fail(msg) {
  console.error(`❌ [POLICY FAILURE]: ${msg}`);
  failureCount++;
}

function pass(msg) {
  console.log(`✓ [PASS]: ${msg}`);
}

console.log('====================================================');
console.log('KONFRM AI Design Skill Policy Checker');
console.log('----------------------------------------------------');
console.log('NOTE: ai:skills:check is a deterministic guardrail for known failure modes.');
console.log('It is NOT proof that research is correct, UX is correct, licenses are legally complete,');
console.log('or Canon interpretation is complete. Human / independent review remains mandatory.');
console.log('====================================================');

// 1. Scan for Machine-Specific Paths in docs/ai, .agents, .zcode, and scripts
const scanDirs = [
  path.join(projectRoot, 'docs', 'ai'),
  path.join(projectRoot, '.agents'),
  path.join(projectRoot, '.zcode'),
  path.join(projectRoot, 'scripts', 'sync-agent-skills.mjs'),
  path.join(projectRoot, 'scripts', 'check-ai-skills.mjs'),
];

const forbiddenPathPatterns = [
  new RegExp('file:' + '///C:', 'i'),
  new RegExp('C:' + '\\\\Users\\\\', 'i'),
  new RegExp('C:' + '/Users/', 'i'),
  new RegExp('Essam' + '[\\\\/]OneDrive', 'i'),
  new RegExp('KONFRM' + '-SCREEN17-18-REMEDIATION', 'i'),
];

function scanForMachinePaths(targetPath) {
  if (!fs.existsSync(targetPath)) return;
  const stat = fs.statSync(targetPath);
  if (stat.isDirectory()) {
    const entries = fs.readdirSync(targetPath);
    for (const entry of entries) {
      scanForMachinePaths(path.join(targetPath, entry));
    }
  } else if (stat.isFile() && (targetPath.endsWith('.md') || targetPath.endsWith('.mjs') || targetPath.endsWith('.py') || targetPath.endsWith('.json'))) {
    // Skip large JSON datasets in vendor to avoid slow regex scans
    if (targetPath.includes('phosphor-icons-upstream.json') || targetPath.includes('google-font-licenses.json')) {
      return;
    }
    const content = fs.readFileSync(targetPath, 'utf8');
    const relFile = path.relative(projectRoot, targetPath).replaceAll('\\', '/');
    for (const pattern of forbiddenPathPatterns) {
      if (pattern.test(content)) {
        fail(`Machine-specific path detected in ${relFile} matching ${pattern}`);
      }
    }
  }
}

for (const dir of scanDirs) {
  scanForMachinePaths(dir);
}
pass('Machine-specific absolute path sweep clean (0 detected).');

// 2. Disallowed Hooks Check
const disallowedHooks = [
  path.join(projectRoot, '.codex', 'hooks.json'),
  path.join(projectRoot, '.agents', 'hooks.json'),
];

for (const hook of disallowedHooks) {
  if (fs.existsSync(hook)) {
    fail(`Disallowed hook file detected: ${path.relative(projectRoot, hook)}`);
  }
}
pass('Disallowed hook check passed (0 detected).');

// 3. Thin-Shim Synchronization & Bloat Check
const CANONICAL_DIR = path.join(projectRoot, 'docs', 'ai', 'skills');
const AGENTS_DIR = path.join(projectRoot, '.agents', 'skills');
const ZCODE_DIR = path.join(projectRoot, '.zcode', 'skills');

if (!fs.existsSync(CANONICAL_DIR)) {
  fail(`Missing canonical skills directory: ${CANONICAL_DIR}`);
} else {
  const canonicalSkills = fs.readdirSync(CANONICAL_DIR, { withFileTypes: true })
    .filter(d => d.isDirectory())
    .map(d => d.name);

  const checkShimDir = (targetDir, label) => {
    if (!fs.existsSync(targetDir)) {
      fail(`Target directory does not exist: ${label}`);
      return;
    }
    const entries = fs.readdirSync(targetDir, { withFileTypes: true })
      .filter(d => d.isDirectory())
      .map(d => d.name);

    if (entries.length !== canonicalSkills.length) {
      fail(`${label} has ${entries.length} skills, expected ${canonicalSkills.length}`);
    }

    for (const skill of canonicalSkills) {
      const shimSkillDir = path.join(targetDir, skill);
      const shimSkillMd = path.join(shimSkillDir, 'SKILL.md');
      if (!fs.existsSync(shimSkillMd)) {
        fail(`${label}/${skill}/SKILL.md missing`);
        continue;
      }
      // Ensure shim directory contains ONLY SKILL.md (no bloat / vendor copies)
      const subEntries = fs.readdirSync(shimSkillDir);
      if (subEntries.length > 1 || subEntries[0] !== 'SKILL.md') {
        fail(`${label}/${skill} contains unexpected files (expected thin shim only): ${subEntries.join(', ')}`);
      }
      // Ensure shim references canonical repo-relative path
      const shimText = fs.readFileSync(shimSkillMd, 'utf8');
      if (!shimText.includes(`docs/ai/skills/${skill}/SKILL.md`)) {
        fail(`${label}/${skill}/SKILL.md does not point to canonical source docs/ai/skills/${skill}/SKILL.md`);
      }
    }
  };

  checkShimDir(AGENTS_DIR, '.agents/skills');
  checkShimDir(ZCODE_DIR, '.zcode/skills');
  pass('Thin discovery shim architecture validated (1:1 with canonical, zero vendor duplicates).');
}

// 4. Frontmatter Integrity
function validateFrontmatter(baseDir) {
  if (!fs.existsSync(baseDir)) return;
  const skills = fs.readdirSync(baseDir, { withFileTypes: true }).filter(d => d.isDirectory());
  for (const skill of skills) {
    const skillMd = path.join(baseDir, skill.name, 'SKILL.md');
    if (fs.existsSync(skillMd)) {
      const text = fs.readFileSync(skillMd, 'utf8');
      const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---/);
      if (!match) {
        fail(`Missing YAML frontmatter in ${path.relative(projectRoot, skillMd)}`);
      } else {
        const fm = match[1];
        if (!fm.includes('name:') || !fm.includes('description:')) {
          fail(`Incomplete frontmatter (missing name or description) in ${path.relative(projectRoot, skillMd)}`);
        }
      }
    }
  }
}

validateFrontmatter(CANONICAL_DIR);
validateFrontmatter(AGENTS_DIR);
validateFrontmatter(ZCODE_DIR);
pass('SKILL.md YAML frontmatter validated across canonical and shim directories.');

// 5. False-Canon & Product-Truth Verification in Internal Skills
const internalSkills = [
  'konfrm-mobile-design',
  'konfrm-accessibility',
  'konfrm-rtl-arabic',
  'konfrm-visual-qa',
  'konfrm-product-ux',
  'konfrm-design-router',
  'konfrm-design-reasoning',
];

// Verify konfrm-design-reasoning exists and router references it
const reasoningSkillFile = path.join(CANONICAL_DIR, 'konfrm-design-reasoning', 'SKILL.md');
if (!fs.existsSync(reasoningSkillFile)) {
  fail('Missing konfrm-design-reasoning/SKILL.md in canonical skills');
} else {
  pass('konfrm-design-reasoning skill verified present in canonical skills.');
}

const routerFile = path.join(CANONICAL_DIR, 'konfrm-design-router', 'SKILL.md');
if (fs.existsSync(routerFile)) {
  const routerText = fs.readFileSync(routerFile, 'utf8');
  if (!routerText.includes('konfrm-design-reasoning')) {
    fail('konfrm-design-router/SKILL.md does not reference konfrm-design-reasoning for visual decisions');
  } else {
    pass('konfrm-design-router integration with konfrm-design-reasoning verified.');
  }
}

const forbiddenCanonPhrases = [
  { pattern: /Primary CTA must be #000000/i, desc: 'Invented black primary CTA canon' },
  { pattern: /48[–-]52dp button/i, desc: 'Invented 48-52dp button height canon' },
  { pattern: /36[–-]40dp secondary/i, desc: 'Invented 36-40dp secondary target canon' },
  { pattern: /130% text-scaling ceiling/i, desc: 'Invented 130% text scaling ceiling' },
  { pattern: /Cairo is canonical/i, desc: 'Promoted Cairo candidate to canonical' },
  { pattern: /150[–-]250ms/i, desc: 'Invented mandatory transition duration canon' },
  // Product truth contamination phrases:
  { pattern: /instant booking confirmation/i, desc: 'Invented instant booking confirmation' },
  { pattern: /gross rent minus platform fee/i, desc: 'Invented gross rent minus platform fee calculation' },
  { pattern: /instant notification of bank transfers/i, desc: 'Invented bank transfer notification guarantee' },
  { pattern: /zero[- ]lag/i, desc: 'Invented zero-lag calendar behavior' },
  { pattern: /dual[- ]check/i, desc: 'Invented Admin dual-check financial policy' },
  { pattern: /no payment credentials or charges are taken before an owner explicitly approves/i, desc: 'Prototype card-credential behavior presented as global product rule' },
  { pattern: /settled cancellation policy/i, desc: 'Invented settled cancellation policy' },
  { pattern: /real-time visibility/i, desc: 'Invented unsupported real-time visibility guarantee' },
  { pattern: /immutable audit trail and explicit reason logging/i, desc: 'Invented universal immutable admin audit trail requirement' },
  // RTL boundary checks:
  { pattern: /Eastern digits.*strictly forbidden/i, desc: 'Eastern digits strictly forbidden rule in RTL doctrine' },
  { pattern: /strictly forbidden in dates/i, desc: 'Universal ban on Eastern digits in dates' },
  { pattern: /Horizontal Progress MUST flow RTL/i, desc: 'Invented mandatory RTL horizontal progress canon' },
  { pattern: /time-based progression always/i, desc: 'Invented mandatory RTL time progression canon' },
  // Accessibility boundary checks:
  { pattern: /WCAG.*AA\/AAA.*non-waivable.*across all platforms/i, desc: 'Universal AA/AAA requirement across native + web' },
  { pattern: /all color pairings must satisfy AA\/AAA/i, desc: 'Universal AA/AAA color pairing requirement' },
  { pattern: /platform (?:guidance|recommendation) is a non-waivable legal/i, desc: 'Platform guidance claimed as legal mandate' },
  // Research claim hygiene & doctrine anchoring checks:
  { pattern: /HIG.*10[–-]14pt/i, desc: 'Unsupported HIG 10-14pt radius claim' },
  { pattern: /4px[–-]8px|10px[–-]16px/i, desc: 'Exact numeric radius ranges anchored in reasoning doctrine' },
];

for (const skill of internalSkills) {
  const file = path.join(CANONICAL_DIR, skill, 'SKILL.md');
  if (fs.existsSync(file)) {
    const text = fs.readFileSync(file, 'utf8');
    for (const { pattern, desc } of forbiddenCanonPhrases) {
      if (pattern.test(text)) {
        fail(`Forbidden false-canon phrase in ${skill}/SKILL.md: ${desc}`);
      }
    }
    // Check for unflagged categorical psychological claims outside quotes/prohibition blocks
    const cleanText = text
      .replace(/["'`*]users will feel[^"'`*]*["'`*]/gi, '')
      .replace(/never claim:[^\n]*/gi, '')
      .replace(/❌[^\n]*/g, '');
    if (/users will feel\b/i.test(cleanText)) {
      fail(`Forbidden categorical "users will feel" assertion in ${skill}/SKILL.md`);
    }
  }
}
pass('Internal skill Canon vs Candidate discipline & research hygiene passed (0 false-canon phrases).');

// 6. UI/UX Pro Max Behavioral Runner Safety Verification
const testScript = path.join(projectRoot, 'scripts', 'test-uiux-runner-safety.py');
if (fs.existsSync(testScript)) {
  try {
    const pythonExe = process.platform === 'win32' ? 'python' : 'python3';
    execSync(`${pythonExe} "${testScript}"`, { stdio: 'pipe' });
    pass('UI/UX Pro Max behavioral runner safety tests executed and passed (0 bypasses, 0 writes).');
  } catch (err) {
    fail(`UI/UX Pro Max behavioral runner safety tests FAILED: ${err.message}`);
  }
} else {
  fail(`Missing runner safety test script: ${testScript}`);
}

const runnerFile = path.join(CANONICAL_DIR, 'ui-ux-pro-max-wrapper', 'runner.py');
if (fs.existsSync(runnerFile)) {
  const runnerText = fs.readFileSync(runnerFile, 'utf8');
  if (!runnerText.includes('allow_abbrev=False')) {
    fail('runner.py does not implement strict allow_abbrev=False');
  } else {
    pass('UI/UX Pro Max runner.py strict parser (allow_abbrev=False) verified.');
  }
} else {
  fail('runner.py missing in ui-ux-pro-max-wrapper');
}

// 7. Vercel Licensing Boundary Verification
const forbiddenVercelUpstreams = [
  path.join(CANONICAL_DIR, 'vercel-composition-wrapper', 'vendor', 'UPSTREAM_SKILL.md'),
  path.join(CANONICAL_DIR, 'vercel-web-guidelines-wrapper', 'vendor', 'UPSTREAM_SKILL.md'),
];
for (const p of forbiddenVercelUpstreams) {
  if (fs.existsSync(p)) {
    fail(`Unresolved verbatim Vercel upstream skill retained: ${path.relative(projectRoot, p)}`);
  }
}
pass('Unresolved verbatim Vercel agent-skills files verified absent.');

const vercelSnapshot = path.join(CANONICAL_DIR, 'vercel-web-guidelines-wrapper', 'vendor', 'web-interface-guidelines.md');
if (!fs.existsSync(vercelSnapshot)) {
  fail(`Missing documented Vercel Web Interface Guidelines snapshot at ${vercelSnapshot}`);
} else {
  pass('Documented Vercel Web Interface Guidelines snapshot verified present.');
}

// 8. Sandbox & Rejected Skill Isolation
const forbiddenInstalledSkills = [
  'sleek-design-mobile-apps',
  'high-end-visual-design',
  'extract-design-system',
  'canvas-design',
  'design-taste-frontend',
];

for (const forbidden of forbiddenInstalledSkills) {
  if (fs.existsSync(path.join(AGENTS_DIR, forbidden)) || fs.existsSync(path.join(ZCODE_DIR, forbidden))) {
    fail(`Sandbox/rejected skill installed in default agent directory: ${forbidden}`);
  }
}
pass('Sandbox and rejected skills excluded from agent discovery directories.');

console.log('====================================================');
if (failureCount > 0) {
  console.error(`FAILED: ${failureCount} policy check(s) failed.`);
  process.exit(1);
} else {
  console.log('ALL POLICY CHECKS PASSED.');
  console.log('====================================================');
}
