#!/usr/bin/env node
// Regenerates AGENTS.md from skills/swift-common/SKILL.md so the two can never
// drift. SKILL.md (with its YAML frontmatter) is the single source of truth;
// AGENTS.md is its frontmatter-stripped mirror for non-Claude AI tools.
//
//   node scripts/sync-agents.mjs           # write AGENTS.md
//   node scripts/sync-agents.mjs --check   # exit 1 if AGENTS.md is stale
//
// Same behaviour as the canonical @rtorcato/repo-tooling `claude-sync-agents`,
// minus the package.json name lookup: this repo is a Swift package with no root
// package.json, so the skill path is fixed.

import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'

const root = join(dirname(fileURLToPath(import.meta.url)), '..')
const skillRelative = 'skills/swift-common/SKILL.md'
const AGENTS = join(root, 'AGENTS.md')

const HEADER = `<!-- Generated from ${skillRelative} by scripts/sync-agents.mjs — do not edit by hand; run \`node scripts/sync-agents.mjs\`. -->\n\n`

// Strip the leading YAML frontmatter block, keep the markdown body.
const body = readFileSync(join(root, skillRelative), 'utf8').replace(/^---\n[\s\S]*?\n---\n+/, '')
const expected = HEADER + body

if (process.argv.includes('--check')) {
	let current = ''
	try {
		current = readFileSync(AGENTS, 'utf8')
	} catch {
		// AGENTS.md missing → treat as stale below.
	}
	if (current !== expected) {
		console.error(`AGENTS.md is out of sync with ${skillRelative} — run \`node scripts/sync-agents.mjs\`.`)
		process.exit(1)
	}
	console.log(`AGENTS.md is in sync with ${skillRelative}.`)
} else {
	writeFileSync(AGENTS, expected)
	console.log(`Wrote AGENTS.md from ${skillRelative}`)
}
