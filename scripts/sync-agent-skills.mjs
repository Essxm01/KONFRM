#!/usr/bin/env node
/**
 * KONFRM AI Design Skill Synchronizer
 * 
 * Deterministically distributes governed skills from canonical source
 * (docs/ai/skills/) into project-local directories for Codex, Antigravity, and ZCode.
 * Enforces the file-copy principle (--copy, zero symlinks) and validates that no
 * unauthorized binary hooks exist.
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
console.log('KONFRM AI Design Skill Synchronizer');
console.log('====================================================');
console.log(`Source:  ${path.relative(projectRoot, SOURCE_DIR)}`);

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

// Distribute to each target
for (const targetDir of TARGET_DIRS) {
  const relTarget = path.relative(projectRoot, targetDir);
  console.log(`Synchronizing to -> ${relTarget}...`);
  
  if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
  }

  for (const skill of skills) {
    const srcPath = path.join(SOURCE_DIR, skill);
    const destPath = path.join(targetDir, skill);
    
    // Copy recursively using real files (no symlinks)
    fs.cpSync(srcPath, destPath, { recursive: true, force: true });
  }
  console.log(`  ✓ Synced ${skills.length} skills to ${relTarget}`);
}

// Security Check: ensure no unauthorized binary hooks exist
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
console.log('All skills successfully synchronized across Codex, Antigravity, and ZCode.');
console.log('====================================================');
