# TODOs

## Claude Code setup follow-ups

- [ ] Open `/hooks` once (or restart Claude Code) so the new `.claude/settings.json` is picked up by the settings watcher. SwiftLint is installed (v0.63.3) so the auto-fix hook will start working as soon as the watcher loads it.
- [ ] Beef up the test suite or treat tests as decorative. Right now `swift test` doesn't prove much; either add coverage for the high-traffic modules (Networking, Managers, State) or formalize the "tests are sparse" note as policy.
- [x] **Make `swift test` work on the macOS host.** `Examples/` excluded from the SwiftPM target; `ColorHelper`, `ImagePicker`, `AddToWalletButton`, `LocalAuthenticationHelper`, `PaymentButton` properly guarded. All 36 tests pass on macOS host.
- [x] **Full multi-platform audit for watchOS / tvOS.** Guarded `BeaconDetector` (CLProximity), `ImagePicker` (PhotosPickerItem), `EmojiList` (GroupBox), `FlipViewSample` (`.pickerStyle(.segmented)`), and `DismissButton` (`.buttonStyle(.borderless)` requires tvOS 17). `continue-on-error` removed from the `platforms` job — `xcodebuild iOS/macOS/tvOS/watchOS` are now all hard gates alongside `swift test` and `SwiftLint`. `Periphery` remains informational pending a separate dead-code triage pass.
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
- [x] **HTTP client / Fetch** (`Networking/`) — shipped. `APIClient` (async/await, configurable session/decoder/encoder/interceptor/logger), `Endpoint` protocol with `urlRequest(...)` builder, `RequestBody` enum (empty/data/json/form), `NetworkError` (invalidURL/invalidResponse/http/decoding/encoding/transport/cancelled/unknown) with `statusCode` helper and `NetworkError.map(_:)`. 22 tests cover URLProtocol-mocked send, non-2xx mapping, decoding/transport errors, interceptor injection, JSON POST. **Still open:** retry policy (the original ask).

### Add new categories

- [x] **Arrays** (`Extensions/ArrayExt.swift`) — `subscript(safe:)`, `chunked(into:)`, `grouped(by:)`, `unique()`. Stdlib `shuffled()` covers that bullet. **Still missing:** `compactNonNil` for `[T?] -> [T]`.
- [x] **Functions** (`Helpers/FunctionHelper.swift`) — `debounce`, `throttle`, `memoize` (thread-safe, closure-based).
- [x] **Async helpers** (`Helpers/AsyncHelpers.swift`) — `retry(attempts:delay:_:)`, `withTimeout(_:_:)` for `async throws` closures.
- [x] **Sleep** (`Helpers/SleepHelper.swift`) — `SleepHelper.seconds(_:)`, `.milliseconds(_:)`, `.nanoseconds(_:)` over `Task.sleep`.
- [x] **Interval** (`Concurrency/IntervalHelper.swift`) — `every(_:_:)` and `after(_:_:)` returning cancellable `Task<Void, Never>`.
- [x] **Random** (`Helpers/RandomHelper.swift`) — `RandomHelper.int(in:)`, `.double(in:)`, `.bool()`, `.element(from:)`, `.string(length:)`. **Still missing:** `Collection.randomElement(count:)` returning N samples, seeded RNG wrapper.
- [x] **Regex** (`Helpers/RegexHelper.swift`) — `matches(_:in:)`, `allMatches(_:in:)`, `replace(_:with:in:)`, `captureGroups(_:in:)`.
- [x] **Math** (`Helpers/MathHelper.swift`) — `clamp(_:min:max:)`, `lerp(from:to:t:)`, `mapRange(_:fromMin:fromMax:toMin:toMax:)`, `roundedTo(_:places:)`, `degreesToRadians(_:)`, `radiansToDegrees(_:)`.
- [x] **Geometry** (`Helpers/GeometryHelper.swift`) — `distance`, `midpoint`, `center`, `inset`, `contains(_:point:)`, `aspectRatio`.
- [x] **Dictionary** (`Extensions/DictionaryExt.swift`) — `mapKeys`, `filteringKeys`, plus `keysToCamelCase` / `keysToSnakeCase` for JSON-friendly transforms.
- [ ] **Objects / Codable** (`Helpers/CodableHelper.swift`) — partial decode, key omission, deep merge of `[String: Any]`, snake↔camel key conversion.
- [x] **Sets** (`Extensions/SetExt.swift`) — `containsAll(_:)`, `containsAny(_:)`, `toggle(_:)`. The originally-listed `symmetricDifference` and `isSuperset(of:)` shortcuts are already in stdlib `Set`.
- [ ] **Events** (`Events/EventEmitter.swift`) — `Combine`-backed or `NotificationCenter`-backed typed event bus with `on`/`off`/`emit`. Type-safe alternative to raw `NotificationCenter`.
- [x] **Errors** (`Errors/AppError.swift`) — `LocalizedError`-conforming `AppError` with code + message + userInfo. Includes sync + async `Result.tryCatch(_:)` extension covering the "Try / Result" item below.
- [x] **Try / Result** — covered by `Result.tryCatch(_:)` extension on `AppError.swift`.
- [x] **Env** (`Helpers/EnvHelper.swift`) — typed `string` / `int` / `bool` accessors with optional defaults, plus `all`.
- [x] **Logging** (`Logging/AppLogger.swift`) — `os.Logger` wrapper with subsystem/category init and `debug` / `info` / `notice` / `warning` / `error` / `critical` convenience.
- [ ] **Task cancellation** (`Concurrency/Cancellation.swift`) — `withCancellableTask`, group-cancellation helpers, equivalent of JS `AbortController`.
- [ ] **Types / aliases** (`Types/Aliases.swift`) — shared typealiases (`JSONDictionary = [String: Any]`, `Completion<T> = (Result<T, Error>) -> Void`, etc.) so downstream apps don't redefine the same shapes.

### Stretch

- [x] **Rebuild `Networking/` as a proper module.** Done — see "HTTP client / Fetch" above. Networking still lives in `MatrixSwiftBaseCore`. **Next step (still open):** promote it to its own `MatrixSwiftBaseNetworking` SwiftPM product so consumers can depend on it without pulling the rest of Core.
- [x] **Subpath / submodule exports.** Package split into `MatrixSwiftBaseCore` (pure utilities) and `MatrixSwiftBaseUI` (SwiftUI components + UI-coupled helpers). Consumers depending on just Core never compile or link UI code. Networking is currently in Core as a stub; promote to its own `MatrixSwiftBaseNetworking` product when the HTTPClient rebuild lands.
- [x] **Strip unused SwiftUI imports from currently UI-categorized helpers.** `StringHelper`, `DateHelper`, `DoubleHelper`, `ThreadHelper`, and `KeychainManager` all moved from UI to Core after dropping their unused `import SwiftUI` (KeychainManager also had a dead `cache = [UUID: UIImage]()` field removed).
