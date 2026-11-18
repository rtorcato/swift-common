# Changesets

Every PR that changes the Swift library adds a changeset: run `pnpm changeset`,
pick `patch`, `minor` or `major` for `@rtorcato/swift-common`, and describe the
change for consumers. Docs-only and CI-only PRs need none.

Merging to `main` never releases. Each push opens or updates the "Version
Packages" PR; merging it bumps the version and changelog, and the `release`
environment then waits for approval before `release.yml` tags `vX.Y.Z` and
creates the GitHub Release. Nothing goes to npm.
