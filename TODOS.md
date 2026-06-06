# TODOs

## Claude Code setup follow-ups

- [ ] Open `/hooks` once (or restart Claude Code) so the new `.claude/settings.json` is picked up by the settings watcher. SwiftLint is installed (v0.63.3) so the auto-fix hook will start working as soon as the watcher loads it.
- [ ] Beef up the test suite or treat tests as decorative. Right now `swift test` doesn't prove much; either add coverage for the high-traffic modules (Networking, Managers, State) or formalize the "tests are sparse" note as policy.
- [ ] Install the skill-creator plugin with `/plugin install skill-creator@claude-plugins-official`, then `/skill-creator <name>` to author new skills or refine `/verify-platforms` with evals.
- [ ] Browse `/plugin` for official plugins (skills, agents, hooks, MCP servers). You can also publish your own to share with others.
- [ ] Consider a `/release` skill — since this is vendored via git URL, a skill that tags + pushes a version (and updates downstream consumers if you have a known list) could remove friction. Skip if releases are ad-hoc.

## Repo tooling — borrow structure from @rtorcato/js-tooling

- [ ] **Auto-release via semantic-release** — `semantic-release` itself is language-agnostic; with `@semantic-release/github` and `@semantic-release/git` (no npm plugin) it can tag versions and write `CHANGELOG.md` for a Swift package based on conventional commits. Use the `/semantic-release/base` preset from `js-tooling`, not `/github` (which assumes npm publish).

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
