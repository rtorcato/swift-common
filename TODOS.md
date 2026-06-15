# TODOs

Every item below is mirrored as a GitHub issue. Update both when status changes; close the issue when the work lands.

## Open-source readiness

### Blockers
- [x] [#5](https://github.com/rtorcato/swift-common/issues/5) — Add LICENSE (Apache-2.0) and remove the "all-rights-reserved" note in README
- [ ] [#6](https://github.com/rtorcato/swift-common/issues/6) — Set up release automation (semantic-release `/base` preset) and tag `0.1.0`
- [ ] [#7](https://github.com/rtorcato/swift-common/issues/7) — Fix doc/config drift (`CLAUDE.md` paths, `.swiftlint.yml` `Sources/Examples` exclude, `plan.md` note)
- [ ] [#32](https://github.com/rtorcato/swift-common/issues/32) — Resolve tvOS/watchOS gating drift between README Status and `ci.yml`

### Niceties
- [ ] [#8](https://github.com/rtorcato/swift-common/issues/8) — Add `CONTRIBUTING.md`
- [ ] [#9](https://github.com/rtorcato/swift-common/issues/9) — Add `SECURITY.md` and vulnerability disclosure contact
- [ ] [#16](https://github.com/rtorcato/swift-common/issues/16) — Add GitHub issue and PR templates
- [ ] [#10](https://github.com/rtorcato/swift-common/issues/10) — Add DocC catalog and publish to GitHub Pages
- [ ] [#15](https://github.com/rtorcato/swift-common/issues/15) — Add Swift version + platforms badges to README

## Design / library quality

- [ ] [#11](https://github.com/rtorcato/swift-common/issues/11) — Isolate Lottie into its own product or behind a SwiftPM trait
- [ ] [#12](https://github.com/rtorcato/swift-common/issues/12) — Bump `swift-tools-version` from 5.7 to 5.9+
- [ ] [#13](https://github.com/rtorcato/swift-common/issues/13) — Add tests for high-traffic Managers (Keychain / ImageCache / SystemTheme)
- [ ] [#14](https://github.com/rtorcato/swift-common/issues/14) — Sendable audit for Swift 6 strict concurrency

## Foundation utilities — port from `@rtorcato/js-common`

`swift-common` mirrors the role `@rtorcato/js-common` plays for JS projects: a foundation library reusable across every iOS/macOS app. Use Swift idioms (`async`/`await`, `Combine`, `Result`, `os.Logger`) — don't transliterate JS.

### Expand existing coverage

- [ ] [#18](https://github.com/rtorcato/swift-common/issues/18) — Expand validation layer (`Email`, `Phone`, `URL`, `CreditCard`, `Password`, `PostalCode` + composable `Validator<T>` protocol)
- [ ] [#19](https://github.com/rtorcato/swift-common/issues/19) — Add `NumberHelper` (parse, format, validate, clamp; decimal/percent/scientific)
- [ ] [#20](https://github.com/rtorcato/swift-common/issues/20) — Make `DateHelper` public and extend with timezone / ISO-8601 / relative-time / business-day APIs
- [ ] [#23](https://github.com/rtorcato/swift-common/issues/23) — Add retry policy to `APIClient` (the last open Networking item)

### Add new categories

- [ ] [#21](https://github.com/rtorcato/swift-common/issues/21) — Add `SystemInfoHelper` (OS version, device model, locale, bundle ID, app version)
- [ ] [#22](https://github.com/rtorcato/swift-common/issues/22) — Add `LocaleHelper` + `PluralizationHelper` for i18n
- [ ] [#24](https://github.com/rtorcato/swift-common/issues/24) — Add `ArrayExt.compactNonNil` for `[T?] -> [T]`
- [ ] [#25](https://github.com/rtorcato/swift-common/issues/25) — Extend `RandomHelper` with N-element sampling and seeded RNG wrapper
- [ ] [#26](https://github.com/rtorcato/swift-common/issues/26) — Add `CodableHelper` (partial decode, key omission, deep merge, snake↔camel)
- [ ] [#27](https://github.com/rtorcato/swift-common/issues/27) — Add typed `EventEmitter` (Combine-backed event bus)
- [ ] [#28](https://github.com/rtorcato/swift-common/issues/28) — Add `Concurrency/Cancellation` helpers (AbortController equivalent)
- [ ] [#30](https://github.com/rtorcato/swift-common/issues/30) — Add shared `Types/Aliases` (`JSONDictionary`, `Completion<T>`, etc.)

### Stretch

- [ ] [#31](https://github.com/rtorcato/swift-common/issues/31) — Promote Networking to its own SwiftPM product (`MatrixSwiftBaseNetworking`)

## Personal IDE plumbing (not tracked as issues)

Local Claude Code chores. Each requires running a slash command in an interactive session — Claude can't trigger these from a tool call.

- [ ] Run `/hooks` once (or restart Claude Code) so `.claude/settings.json` is picked up. Verified: config is valid JSON and SwiftLint 0.63.3 is on PATH, so the auto-fix hook will run as soon as the watcher loads it.
- [ ] `/plugin install skill-creator@claude-plugins-official`, then use `/skill-creator <name>` to author new skills or refine `/verify-platforms` with evals.
- [ ] Browse `/plugin` for official plugins (skills, agents, hooks, MCP servers).

Decided — not doing:

- ~~Local `/release` skill~~ — superseded by [#6](https://github.com/rtorcato/swift-common/issues/6) (semantic-release `/base` preset). One automation path is enough.
