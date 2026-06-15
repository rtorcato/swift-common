# TODOs

## Open-source readiness (tracked as GitHub issues)

Items below are mirrored as GitHub issues. Update both when status changes.

### Blockers
- [ ] [#5](https://github.com/rtorcato/swift-common/issues/5) — Add LICENSE (Apache-2.0) and remove all-rights-reserved note
- [ ] [#6](https://github.com/rtorcato/swift-common/issues/6) — Set up release automation (semantic-release `/base` preset) and tag `0.1.0`
- [ ] [#7](https://github.com/rtorcato/swift-common/issues/7) — Fix doc/config drift (CLAUDE.md paths, `.swiftlint.yml` exclude, `plan.md` note)

### Open-source niceties
- [ ] [#8](https://github.com/rtorcato/swift-common/issues/8) — Add `CONTRIBUTING.md`
- [ ] [#9](https://github.com/rtorcato/swift-common/issues/9) — Add `SECURITY.md` and vulnerability disclosure contact
- [ ] [#16](https://github.com/rtorcato/swift-common/issues/16) — Add GitHub issue and PR templates
- [ ] [#10](https://github.com/rtorcato/swift-common/issues/10) — Add DocC catalog and publish to GitHub Pages
- [ ] [#17](https://github.com/rtorcato/swift-common/issues/17) — Scaffold Docusaurus docs site at `apps/docs/` (mirror browser-common setup)
- [ ] [#15](https://github.com/rtorcato/swift-common/issues/15) — Add Swift version + platforms badges to README

### Design / library quality
- [ ] [#11](https://github.com/rtorcato/swift-common/issues/11) — Isolate Lottie into its own product or behind a SwiftPM trait
- [ ] [#12](https://github.com/rtorcato/swift-common/issues/12) — Bump `swift-tools-version` from 5.7 to 5.9+
- [ ] [#13](https://github.com/rtorcato/swift-common/issues/13) — Add tests for high-traffic Managers (Keychain / ImageCache / SystemTheme)
- [ ] [#14](https://github.com/rtorcato/swift-common/issues/14) — Sendable audit for Swift 6 strict concurrency

## Claude Code setup follow-ups

- [ ] Open `/hooks` once (or restart Claude Code) so the new `.claude/settings.json` is picked up by the settings watcher. SwiftLint is installed (v0.63.3) so the auto-fix hook will start working as soon as the watcher loads it.
- [ ] Beef up the test suite or treat tests as decorative. Right now `swift test` doesn't prove much; either add coverage for the high-traffic modules (Networking, Managers, State) or formalize the "tests are sparse" note as policy.
- [ ] Install the skill-creator plugin with `/plugin install skill-creator@claude-plugins-official`, then `/skill-creator <name>` to author new skills or refine `/verify-platforms` with evals.
- [ ] Browse `/plugin` for official plugins (skills, agents, hooks, MCP servers). You can also publish your own to share with others.
- [ ] Consider a `/release` skill — since this is vendored via git URL, a skill that tags + pushes a version (and updates downstream consumers if you have a known list) could remove friction. Skip if releases are ad-hoc.

## Repo tooling — borrow structure from @rtorcato/js-tooling

- [ ] **Auto-release via semantic-release** — tracked as [#6](https://github.com/rtorcato/swift-common/issues/6). `semantic-release` itself is language-agnostic; with `@semantic-release/github` and `@semantic-release/git` (no npm plugin) it can tag versions and write `CHANGELOG.md` for a Swift package based on conventional commits. Use the `/semantic-release/base` preset from `js-tooling`, not `/github` (which assumes npm publish).

## Foundation utilities — port from @rtorcato/js-common

`swift-common` mirrors the role `@rtorcato/js-common` plays for JS projects: a foundation library reusable across every iOS/macOS app. The items below are the remaining gaps. Each bullet lists the target file/folder under `Sources/MatrixSwiftBaseCore/` and the headline APIs to expose. Use Swift idioms (`async`/`await`, `Combine`, `Result`, `os.Logger`) — don't transliterate JS.

### Expand partial coverage

- [ ] **Validation** (`Validations/`) — currently one file. Add `Email`, `Phone`, `URL`, `CreditCard`, `Password`, `PostalCode` validators as a coherent rule-based layer (`Validator<T>` protocol with composable rules).
- [ ] **Numbers / formatting** (`Helpers/NumberHelper.swift`) — parse, format, validate, clamp, decimal/percent/scientific formatting. Pull related pieces out of `DoubleHelper` / `UnitHelper` if it makes sense.
- [ ] **Datetime / time** (`Helpers/DateTimeHelper.swift`, `Helpers/TimeZoneHelper.swift`) — extend the existing `DateHelper` with timezone conversion, ISO-8601 round-trip, relative-time formatting ("3 hours ago"), business-day math.
- [ ] **System info** (`Helpers/SystemInfoHelper.swift`) — OS version, device model, locale, bundle ID, app version. Sits alongside the existing `ScreenHelper` / `SizeClassHelper`.
- [ ] **i18n** (`Helpers/LocaleHelper.swift`, `Helpers/PluralizationHelper.swift`) — runtime locale switching, pluralization rules, currency-by-locale.
- [ ] **HTTP client / Fetch** (`Networking/`) — `APIClient`, `Endpoint`, `RequestBody`, `NetworkError` shipped with 22 tests. **Still open:** retry policy (the original ask).

### Add new categories

- [ ] **Arrays** (`Extensions/ArrayExt.swift`) — **Still missing:** `compactNonNil` for `[T?] -> [T]`.
- [ ] **Random** (`Helpers/RandomHelper.swift`) — **Still missing:** `Collection.randomElement(count:)` returning N samples, seeded RNG wrapper.
- [ ] **Objects / Codable** (`Helpers/CodableHelper.swift`) — partial decode, key omission, deep merge of `[String: Any]`, snake↔camel key conversion.
- [ ] **Events** (`Events/EventEmitter.swift`) — `Combine`-backed or `NotificationCenter`-backed typed event bus with `on`/`off`/`emit`. Type-safe alternative to raw `NotificationCenter`.
- [ ] **Task cancellation** (`Concurrency/Cancellation.swift`) — `withCancellableTask`, group-cancellation helpers, equivalent of JS `AbortController`.
- [ ] **Types / aliases** (`Types/Aliases.swift`) — shared typealiases (`JSONDictionary = [String: Any]`, `Completion<T> = (Result<T, Error>) -> Void`, etc.) so downstream apps don't redefine the same shapes.

### Stretch

- [ ] **Promote Networking to its own SwiftPM product** — Networking currently lives in `MatrixSwiftBaseCore`. Split it into a `MatrixSwiftBaseNetworking` product so consumers can depend on it without pulling the rest of Core.
