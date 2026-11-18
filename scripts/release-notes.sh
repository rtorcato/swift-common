#!/usr/bin/env bash
# Prints the CHANGELOG.md section for one version, as written by
# `changeset version` ("## 0.3.1" up to the next "## " heading).
# Usage: scripts/release-notes.sh <version> [changelog-path]
set -euo pipefail

version="${1:?usage: release-notes.sh <version> [changelog-path]}"
file="${2:-CHANGELOG.md}"

awk -v v="$version" '
  $0 == "## " v { found = 1; next }
  found && /^## / { exit }
  found { print }
' "$file"
