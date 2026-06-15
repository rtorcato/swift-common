// Copy the root CHANGELOG.md into apps/docs/docs/changelog.md with Docusaurus
// frontmatter, so semantic-release can keep owning a single canonical changelog
// while the docs site renders it in-nav. The output file is gitignored — it is
// regenerated on every docs build (wired as apps/docs's `prebuild` / `predev`
// / `prestart` scripts).

import { readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const here = dirname(fileURLToPath(import.meta.url))
const repoRoot = resolve(here, '..')
const source = resolve(repoRoot, 'CHANGELOG.md')
const target = resolve(repoRoot, 'apps/docs/docs/changelog.md')

const frontmatter = `---
title: Changelog
description: Release notes for swift-common. Maintained by semantic-release.
---

`

let body = ''
try {
	body = readFileSync(source, 'utf8')
} catch {
	body = '# Changelog\n\nNo releases recorded yet.\n'
}

writeFileSync(target, frontmatter + body)
console.log(`sync-changelog: wrote ${target}`)
