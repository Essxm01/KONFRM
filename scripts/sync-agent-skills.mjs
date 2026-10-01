#!/usr/bin/env node
/**
 * KONFRM AI Design Skill Synchronizer
 * 
 * Generates lightweight discovery shims in .agents/skills/ and .zcode/skills/
 * pointing directly to the canonical source of truth in docs/ai/skills/.
 * Prevents PR bloat and duplicate storage while ensuring full discovery across
 * Codex, Antigravity, and ZCode.
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.resolve(__dirname, '..');

const SOURCE_DIR = path.join(projectRoot, 'docs', 'ai', 'skills');
const TARGET_DIRS = [
  path.join(projectRoot, '.agents', 'skills'), // Codex & Antigravity
  path.join(projectRoot, '.zcode', 'skills'),  // ZCode
];

console.log('====================================================');
console.log('KONFRM AI Design Skill Synchronizer (Thin Shim Mode)');
console.log('====================================================');
console.log(`Canonical Source: docs/ai/skills`);

if (!fs.existsSync(SOURCE_DIR)) {
  console.error(`[ERROR]: Canonical source directory does not exist: ${SOURCE_DIR}`);
  process.exit(1);
}

const skills = fs.readdirSync(SOURCE_DIR, { withFileTypes: true })
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name);

console.log(`Found ${skills.length} governed skills in canonical source:`);
skills.forEach(s => console.log(`  - ${s}`));
console.log();

// Synchronize thin shims to each target directory
for (const targetDir of TARGET_DIRS) {
  const relTarget = path.relative(projectRoot, targetDir).replaceAll('\\', '/');
  console.log(`Generating thin discovery shims in -> ${relTarget}...`);
  
  if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
  }

  for (const skill of skills) {
    const srcSkillMd = path.join(SOURCE_DIR, skill, 'SKILL.md');
    const destSkillDir = path.join(targetDir, skill);
    const destSkillMd = path.join(destSkillDir, 'SKILL.md');

    if (!fs.existsSync(srcSkillMd)) {
      console.warn(`  [WARN]: Missing SKILL.md in source: ${skill}`);
      continue;
    }

    // Clean destination directory to remove any previously copied vendor trees
    if (fs.existsSync(destSkillDir)) {
      fs.rmSync(destSkillDir, { recursive: true, force: true });
    }
    fs.mkdirSync(destSkillDir, { recursive: true });

    // Extract frontmatter from canonical SKILL.md
    const srcContent = fs.readFileSync(srcSkillMd, 'utf8');
    const fmMatch = srcContent.match(/^---\r?\n([\s\S]*?)\r?\n---/);
    let frontmatter = `name: ${skill}\ndescription: "KONFRM governed design skill: ${skill}."`;
    if (fmMatch) {
      frontmatter = fmMatch[1].trim();
    }

    // Author thin discovery shim pointing to repo-relative canonical document
    const shimContent = [
      '---',
      frontmatter,
      '---',
      '',
      `# ${skill} (Discovery Shim)`,
      '',
      'This is an agent discovery shim. The canonical, governed implementation and reference material for this skill is maintained in the KONFRM repository at:',
      '',
      `\`docs/ai/skills/${skill}/SKILL.md\``,
      '',
      `> Refer directly to \`docs/ai/skills/${skill}/SKILL.md\` for complete instructions, guardrails, and usage contracts.`,
      '',
    ].join('\n');

    fs.writeFileSync(destSkillMd, shimContent, 'utf8');
  }
  console.log(`  ✓ Generated ${skills.length} thin discovery shims in ${relTarget}`);
}

// Security Check: verify zero disallowed binary hooks exist
const disallowedHookPaths = [
  path.join(projectRoot, '.codex', 'hooks.json'),
  path.join(projectRoot, '.agents', 'hooks.json'),
];

for (const hookPath of disallowedHookPaths) {
  if (fs.existsSync(hookPath)) {
    console.error(`[SECURITY VIOLATION]: Unauthorized hook file detected: ${hookPath}`);
    process.exit(1);
  }
}

console.log();
console.log('Security check passed: 0 unauthorized binary hooks.');
console.log('Thin discovery shims synchronized successfully across Codex, Antigravity, and ZCode.');
console.log('====================================================');
