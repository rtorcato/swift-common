# Roadmap

This file tracks the same work as the [GitHub milestones](https://github.com/rtorcato/swift-common/milestones). When one changes, change the other. Issue numbers link to the source of truth, and `TODOS.md` carries the finer-grained backlog.

Only the repository owner closes a milestone. Closing one releases nothing; a release is a separate, approved step (see the checklist below).

## Shipped

### [v0.3](https://github.com/rtorcato/swift-common/milestone/2) — pre-dogfood hardening

Released as `v0.3.0` (2026-10-21).

- [x] [#14](https://github.com/rtorcato/swift-common/issues/14) Swift 6 `Sendable` audit and strict concurrency checking
- [x] [#13](https://github.com/rtorcato/swift-common/issues/13) Tests for the high-traffic managers (Keychain, ImageCache, SystemTheme)
- [x] [#11](https://github.com/rtorcato/swift-common/issues/11) Lottie isolated into the `MatrixSwiftBaseLottie` product
- [x] [#59](https://github.com/rtorcato/swift-common/issues/59) Migrate to `@rtorcato/repo-tooling`
- [x] [#93](https://github.com/rtorcato/swift-common/issues/93) Release automation moved from semantic-release to Changesets

Earlier releases: `v0.2.0` (swift-tools-version 5.9) and `v0.1.0` (Apache-2.0 licence, first tag).

## Beta — 0.4.x

[Milestone](https://github.com/rtorcato/swift-common/milestone/3). The `@rtorcato/js-common` parity helpers land, plus community-health files and docs fixes. The API may still change between 0.x releases.

### Core helpers

- [ ] [#18](https://github.com/rtorcato/swift-common/issues/18) Validation layer: Email, Phone, URL, CreditCard, Password, PostalCode and a composable `Validator<T>`
- [ ] [#19](https://github.com/rtorcato/swift-common/issues/19) `NumberHelper`
- [ ] [#20](https://github.com/rtorcato/swift-common/issues/20) Public `DateHelper` with timezone, ISO-8601, relative-time and business-day APIs
- [ ] [#21](https://github.com/rtorcato/swift-common/issues/21) `SystemInfoHelper`
- [ ] [#22](https://github.com/rtorcato/swift-common/issues/22) `LocaleHelper` and `PluralizationHelper`
- [ ] [#23](https://github.com/rtorcato/swift-common/issues/23) Retry policy for `APIClient`
- [ ] [#24](https://github.com/rtorcato/swift-common/issues/24) `ArrayExt.compactNonNil` and other array conveniences
- [ ] [#25](https://github.com/rtorcato/swift-common/issues/25) `RandomHelper` sampling and seeded RNG
- [ ] [#26](https://github.com/rtorcato/swift-common/issues/26) `CodableHelper`
- [ ] [#27](https://github.com/rtorcato/swift-common/issues/27) Typed `EventEmitter`
- [ ] [#28](https://github.com/rtorcato/swift-common/issues/28) Concurrency and cancellation helpers

### Community health and docs

- [ ] [#8](https://github.com/rtorcato/swift-common/issues/8) `CONTRIBUTING.md`
- [ ] [#9](https://github.com/rtorcato/swift-common/issues/9) `SECURITY.md`
- [ ] [#16](https://github.com/rtorcato/swift-common/issues/16) Issue and PR templates
- [ ] [#15](https://github.com/rtorcato/swift-common/issues/15) Swift version and platform badges in the README
- [ ] [#57](https://github.com/rtorcato/swift-common/issues/57) Docs code blocks stay dark in light mode
- [ ] [#39](https://github.com/rtorcato/swift-common/issues/39) This roadmap and the milestone setup

### Release tooling

- [ ] [#70](https://github.com/rtorcato/swift-common/issues/70) Install release tooling from the frozen lockfile
- [ ] [#60](https://github.com/rtorcato/swift-common/issues/60) Retire or refresh the stale `sync-changelog.mjs`

## v1.0 — Stable API

[Milestone](https://github.com/rtorcato/swift-common/milestone/4). The public surface is settled, documented and covered by semantic versioning.

- [ ] [#10](https://github.com/rtorcato/swift-common/issues/10) DocC catalog published to GitHub Pages
- [ ] [#33](https://github.com/rtorcato/swift-common/issues/33) Audit and prune extensions against SwifterSwift
- [ ] [#30](https://github.com/rtorcato/swift-common/issues/30) Shared type aliases (`JSONDictionary`, `Completion<T>`, and similar)
- [ ] [#31](https://github.com/rtorcato/swift-common/issues/31) Decide whether Networking becomes its own SwiftPM product (`MatrixSwiftBaseNetworking`)

Exit criteria for 1.0: every item above is done or explicitly dropped, no public API is marked experimental, and the docs site and README describe the final surface.

## Not scheduled

Parked work lives in the [Backlog milestone](https://github.com/rtorcato/swift-common/milestone/1), for example [#58](https://github.com/rtorcato/swift-common/issues/58) (commits attributed to a placeholder git identity). Nothing there is promised for a release.

## Release checklist

Merging to `main` never releases. Releases use Changesets, and the `release` environment waits for the owner's approval. Nothing is published to npm, because SwiftPM resolves by git tag.

A release that adds or changes a public API must also:

- [ ] Update the docs site (`apps/docs`)
- [ ] Update the README (examples and API reference)
- [ ] Tick the matching item in this file and in the milestone

Every release:

1. Each library-changing PR carries a changeset (`pnpm changeset`). Docs-only and CI-only PRs need none.
2. The "Version Packages" PR bumps the version and changelog. Merging it is the release decision.
3. The owner approves the `release` environment. The run then tags `vX.Y.Z` and creates the GitHub Release.
