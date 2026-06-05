# TODOs

## Claude Code setup follow-ups

- [ ] Open `/hooks` once (or restart Claude Code) so the new `.claude/settings.json` is picked up by the settings watcher. SwiftLint is installed (v0.63.3) so the auto-fix hook will start working as soon as the watcher loads it.
- [ ] Beef up the test suite or treat tests as decorative. Right now `swift test` doesn't prove much; either add coverage for the high-traffic modules (Networking, Managers, State) or formalize the "tests are sparse" note as policy.
- [x] **Make `swift test` work on the macOS host.** `Examples/` excluded from the SwiftPM target; `ColorHelper`, `ImagePicker`, `AddToWalletButton`, and `LocalAuthenticationHelper` properly guarded with `#if canImport(UIKit)` / `#if os(iOS)`. All 36 tests pass on macOS host.
- [ ] Install the skill-creator plugin with `/plugin install skill-creator@claude-plugins-official`, then `/skill-creator <name>` to author new skills or refine `/verify-platforms` with evals.
- [ ] Browse `/plugin` for official plugins (skills, agents, hooks, MCP servers). You can also publish your own to share with others.
- [ ] Consider a `/release` skill — since this is vendored via git URL, a skill that tags + pushes a version (and updates downstream consumers if you have a known list) could remove friction. Skip if releases are ad-hoc.

## Repo tooling — borrow structure from @rtorcato/js-tooling

The patterns the user's `js-tooling` package scaffolds for TS projects have Swift equivalents worth adopting here.

- [x] **GitHub Actions CI** (`.github/workflows/ci.yml`) — runs `swift build` + `swift test` and an `xcodebuild` matrix across iOS / macOS / tvOS / watchOS with SwiftPM + DerivedData caching.
- [x] **SwiftLint in CI** — separate `lint` job runs `swiftlint lint --strict` with the `github-actions-logging` reporter.
- [x] **Dependabot** (`.github/dependabot.yml`) — weekly updates for the `swift` (SwiftPM) and `github-actions` ecosystems.
- [x] **CodeQL** (`.github/workflows/codeql.yml`) — weekly scheduled scan plus push/PR triggers; uses CodeQL's Swift autobuild.
- [x] **`.editorconfig`** — UTF-8, LF, 4-space indent for Swift; 2-space for YAML/JSON; tab for Makefile.
- [x] **Conventional commits + commit-msg hook** — wired via `pre-commit` framework: `conventional-pre-commit` runs at `commit-msg` stage, enforcing `feat:` / `fix:` / `chore:` / `docs:` / `refactor:` / `test:` / `build:` / `ci:` / `perf:` / `style:` / `revert:` prefixes.
- [ ] **Auto-release via semantic-release** — `semantic-release` itself is language-agnostic; with `@semantic-release/github` and `@semantic-release/git` (no npm plugin) it can tag versions and write `CHANGELOG.md` for a Swift package based on conventional commits. Use the `/semantic-release/base` preset from `js-tooling`, not `/github` (which assumes npm publish).
- [x] **Dead-code detection** — `.periphery.yml` configured with `retain_public: true` (library mode), `dead-code` job added to CI runs `periphery scan --strict`.
- [x] **`pre-commit` framework** — `.pre-commit-config.yaml` runs SwiftLint (`--fix`) at pre-commit stage and `conventional-pre-commit` at commit-msg stage. **One-time setup:** `brew install pre-commit && pre-commit install --install-hooks`. Periphery is CI-only (too slow for per-commit).

## Foundation utilities — port from @rtorcato/js-common

`swift-common` mirrors the role `@rtorcato/js-common` plays for JS projects: a foundation library reusable across every iOS/macOS app. The current code is heavy on UI primitives (Components, Helpers, Views) but light on the language-agnostic utilities that `js-common` exposes as 46 subpath exports. The items below are the gaps. Each bullet lists the target file/folder under `Sources/MatrixSwiftBase/` and the headline APIs to expose. Use Swift idioms (`async`/`await`, `Combine`, `Result`, `os.Logger`) — don't transliterate JS.

### Expand partial coverage

- [ ] **Validation** (`Validations/`) — currently one file. Add `Email`, `Phone`, `URL`, `CreditCard`, `Password`, `PostalCode` validators as a coherent rule-based layer (`Validator<T>` protocol with composable rules).
- [ ] **Numbers / formatting** (`Helpers/NumberHelper.swift`) — parse, format, validate, clamp, decimal/percent/scientific formatting. Pull related pieces out of `DoubleHelper` / `UnitHelper` if it makes sense.
- [ ] **Datetime / time** (`Helpers/DateTimeHelper.swift`, `Helpers/TimeZoneHelper.swift`) — extend the existing `DateHelper` with timezone conversion, ISO-8601 round-trip, relative-time formatting ("3 hours ago"), business-day math.
- [ ] **MIME types** (`Helpers/MimeTypeHelper.swift`) — general extension↔MIME mapping using `UniformTypeIdentifiers` (UTType). Promotes the narrow `ImageFileTypes` / `SoundFileTypes` models to a general utility.
- [ ] **System info** (`Helpers/SystemInfoHelper.swift`) — OS version, device model, locale, bundle ID, app version. Sits alongside the existing `ScreenHelper` / `SizeClassHelper`.
- [ ] **i18n** (`Helpers/LocaleHelper.swift`, `Helpers/PluralizationHelper.swift`) — runtime locale switching, pluralization rules, currency-by-locale.
- [ ] **HTTP client / Fetch** (`Networking/`) — the current `Networking/` is a stub (just `HttpMethod` + `NetworkError`). Build a real `HTTPClient` with `URLRequest` builder, async/await calls, retry policy, decoding via `Codable`. Replace `NetworkError` with a richer error hierarchy. This is the single biggest gap for reusability.

### Add new categories

- [ ] **Arrays** (`Extensions/Array+Common.swift`) — `unique()`, `chunked(into:)`, `compactNonNil`, `groupBy(_:)`, `shuffled()`, safe `subscript(safe:)`.
- [ ] **Functions** (`Helpers/FunctionHelper.swift`) — `debounce`, `throttle`, `memoize` (closure-based + `Combine` operators where useful).
- [ ] **Async helpers** (`Concurrency/AsyncHelpers.swift`) — `delay(_:)`, `retry(times:delay:_:)`, `race(_:)`, `withTimeout(_:_:)` for `async throws` closures.
- [ ] **Sleep** (`Concurrency/Sleep.swift`) — typed wrapper over `Task.sleep` (`Sleep.seconds(_:)`, `Sleep.milliseconds(_:)`).
- [ ] **Interval** (`Concurrency/Interval.swift`) — `Task`-based repeating interval with cancellation; modern alternative to `Timer`.
- [ ] **Random** (`Helpers/RandomHelper.swift`) — random int/double/bool/string, `Collection.randomElement(count:)`, seeded RNG wrapper.
- [ ] **Regex** (`Helpers/RegexHelper.swift`) — Swift `Regex` + `NSRegularExpression` wrappers: `matches(_:in:)`, `replace(_:with:in:)`, named-capture extraction.
- [ ] **Math** (`Helpers/MathHelper.swift`) — `clamp`, `lerp`, `mapRange`, `roundedTo(places:)`, `degreesToRadians` / `radiansToDegrees`.
- [ ] **Geometry** (`Helpers/GeometryHelper.swift`) — `CGPoint` / `CGRect` / `CGSize` math: distance, midpoint, intersection, center, inset. Distinct from the existing `Shapes/` folder (those are drawable SwiftUI shapes, this is computation).
- [ ] **Dictionary** (`Extensions/Dictionary+Common.swift`) — `merging(_:strategy:)`, `mapValues`, `filterKeys`, `compactMapValues`, JSON-friendly key transforms.
- [ ] **Objects / Codable** (`Helpers/CodableHelper.swift`) — partial decode, key omission, deep merge of `[String: Any]`, snake↔camel key conversion.
- [ ] **Sets** (`Extensions/Set+Common.swift`) — set-algebra helpers, symmetric-difference convenience, `isSuperset(of:)` shortcuts.
- [ ] **Events** (`Events/EventEmitter.swift`) — `Combine`-backed or `NotificationCenter`-backed typed event bus with `on`/`off`/`emit`. Type-safe alternative to raw `NotificationCenter`.
- [ ] **Errors** (`Errors/AppError.swift`) — `LocalizedError`-conforming base type with code + userInfo, plus `Result` helpers. Promotes `NetworkError` from being the only error type.
- [ ] **Try / Result** (`Helpers/ResultHelper.swift`) — `Result.tryCatch(_:)`, async-throws ↔ `Result` bridges, `attempt(_:)` for swallowing-or-logging.
- [ ] **Env** (`Helpers/EnvHelper.swift`) — typed `ProcessInfo` env-var accessors with defaults (`env("API_URL", default: "...")`).
- [ ] **Logging** (`Logging/Logger.swift`) — thin wrapper over `os.Logger` with level-tagged convenience methods and consistent subsystem/category. Don't rebuild `os.Logger` — just standardize how the package and downstream apps use it.
- [ ] **Task cancellation** (`Concurrency/Cancellation.swift`) — `withCancellableTask`, group-cancellation helpers, equivalent of JS `AbortController`.
- [ ] **Types / aliases** (`Types/Aliases.swift`) — shared typealiases (`JSONDictionary = [String: Any]`, `Completion<T> = (Result<T, Error>) -> Void`, etc.) so downstream apps don't redefine the same shapes.

### Stretch

- [ ] **Rebuild `Networking/` as a proper module.** Listed above under "Expand partial coverage" but worth flagging separately: until there's a real `HTTPClient`, every consumer iOS app will roll its own. This is the single change that would most improve the package's reusability claim.
- [ ] **Subpath / submodule exports.** `js-common` exposes each category as its own subpath (e.g., `@rtorcato/js-common/arrays`) so consumers tree-shake. Swift's equivalent is splitting the single `MatrixSwiftBase` target into multiple library products (`MatrixSwiftBaseCore`, `MatrixSwiftBaseUI`, `MatrixSwiftBaseNetworking`) so apps that only need utilities don't pull in the UI layer. Consider this once the foundation utilities above land.
