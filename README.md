# swift-common

[![CI](https://github.com/rtorcato/swift-common/actions/workflows/ci.yml/badge.svg)](https://github.com/rtorcato/swift-common/actions/workflows/ci.yml)
[![CodeQL](https://github.com/rtorcato/swift-common/actions/workflows/codeql.yml/badge.svg)](https://github.com/rtorcato/swift-common/actions/workflows/codeql.yml)
[![Deploy Docs](https://github.com/rtorcato/swift-common/actions/workflows/docs.yml/badge.svg)](https://github.com/rtorcato/swift-common/actions/workflows/docs.yml)

A reusable foundation library for Apple platforms — the Swift counterpart to [`@rtorcato/js-common`](https://github.com/rtorcato/js-common). Built on top of Foundation and SwiftUI; designed to be added to any iOS / macOS app as a SwiftPM dependency.

📚 **Documentation: <https://rtorcato.github.io/swift-common/>** (source under [`apps/docs/`](./apps/docs/))

The library ships as **two products** so consumers only pay for what they use:

- **`MatrixSwiftBaseCore`** — pure Foundation utilities. No `import SwiftUI` / `import UIKit` / `import AppKit`. Safe to depend on from anywhere, including command-line tools.
  - **Helpers:** `DateHelper`, `MathHelper`, `RandomHelper`, `SleepHelper`, `JsonHelper`, `CryptoHelper`, `CurrencyHelper`, `CoreDataHelper`, `NetworkHelper`, `SoundHelper`, etc.
  - **Extensions:** `Array+`, `Set+`, `Bool+`, `Date+`, `URL+`.
  - **Networking / State / Validations / Models:** `HttpMethod`, `NetworkError`, validation rules, file-type enums.
  - **Managers:** `LocationManager` (more to come as the SwiftUI coupling is unwound).

- **`MatrixSwiftBaseUI`** — SwiftUI components and the SwiftUI-coupled helpers. Depends on Core.
  - **Components / Views / Modifiers / Shapes / Styles** — buttons, containers, form wrappers, loading views, blur effects, rounded corners.
  - **UI Helpers** — `AlertHelper`, `KeyboardHelper`, `ColorHelper`, `SafeAreaHelper`, `SizeClassHelper`, `ScreenHelper`, `StringHelper`, etc.
  - **UI Managers** — `KeychainManager`, `ImageCache`, `ImagePicker`, `SystemThemeManager`, `BeaconDetector`, `SoundManager`, `MessageUIManager`.

A consumer depending on just `MatrixSwiftBaseCore` never compiles or links any UI code — Swift's product isolation gives the same effect as keeping the UI in a separate repo, without the operational tax.

## Scope

`swift-common` is the **application-utility layer** — managers, helpers, networking, validation, and SwiftUI components reused across my iOS / macOS apps. It is **not** a stdlib-extension library.

**Belongs here:**

- Stateful managers (`KeychainManager`, `ImageCache`, `SystemThemeManager`, `LocationManager`, `BeaconDetector`).
- Networking — `APIClient`, `HttpMethod`, `NetworkError` (retry policy planned, [#23](https://github.com/rtorcato/swift-common/issues/23)).
- Validation rules and domain helpers (`CurrencyHelper`, `CryptoHelper`, `JsonHelper`, `DateHelper`, `MathHelper`).
- SwiftUI primitives tuned to my conventions — components, containers, modifiers, shapes, styles.

**Deliberately left to the ecosystem:**

| Need | Use |
| --- | --- |
| Stdlib extensions (`Array+`, `String+`, `Date+`, `View+`) | [SwifterSwift](https://github.com/SwifterSwift/SwifterSwift) |
| Heavy networking (interceptors, multipart, OAuth) | [Alamofire](https://github.com/Alamofire/Alamofire) |
| Image loading / caching at scale | [Kingfisher](https://github.com/onevcat/Kingfisher) |
| Typed `UserDefaults` | [Defaults](https://github.com/sindresorhus/Defaults) |
| General SwiftUI extension layer | [SwiftUIX](https://github.com/SwiftUIX/SwiftUIX) |

The few extensions still in `Sources/MatrixSwiftBaseCore/Extensions/` exist for legacy reasons and will be pruned where they overlap with SwifterSwift.

## Requirements

- Swift 5.7+
- iOS 16+, macOS 13+, tvOS 16+, watchOS 9+ — see Status below for the actual compile-tested matrix.

## Installation

Add the package to your `Package.swift`:

```swift
.package(url: "https://github.com/rtorcato/swift-common", branch: "main"),
```

…then add one or both products to your target's dependencies:

```swift
// Just the utilities
.product(name: "MatrixSwiftBaseCore", package: "swift-common"),

// Utilities + UI primitives
.product(name: "MatrixSwiftBaseCore", package: "swift-common"),
.product(name: "MatrixSwiftBaseUI", package: "swift-common"),
```

Then import the modules you actually use:

```swift
import MatrixSwiftBaseCore
import MatrixSwiftBaseUI   // only if you need the SwiftUI primitives
```

Or in Xcode: **File → Add Package Dependencies…**, paste the repo URL, and pick which product(s) to link.

## Usage

```swift
import MatrixSwiftBaseCore

// Helpers
let value = MathHelper.clamp(150, min: 0, max: 100)             // 100
try await SleepHelper.milliseconds(250)
let random = RandomHelper.string(length: 16)

// Extensions
let chunks = [1, 2, 3, 4, 5].chunked(into: 2)                    // [[1,2],[3,4],[5]]
let safe = ["a", "b"][safe: 5]                                   // nil
var set: Set = [1, 2]
set.toggle(3)                                                    // [1, 2, 3]
```

```swift
import MatrixSwiftBaseUI

struct ContentView: View {
    @StateObject var theme = SystemThemeManager()
    var body: some View {
        // Use the UI helpers, components, and managers
        CardContainer { ... }
    }
}
```

## Development

The repository is set up for an Xcode-primary workflow but also supports the CLI.

| Task | Command |
| --- | --- |
| Build | `swift build` |
| Test | `swift test` |
| Lint | `swiftlint lint --strict` |
| Verify all Apple platforms | `/verify-platforms` (Claude Code skill) or `xcodebuild -scheme MatrixSwiftBase -destination 'generic/platform=iOS' build` |

A `pre-commit` framework config is checked in. One-time setup:

```bash
brew install pre-commit
pre-commit install --install-hooks
```

This wires up auto-`swiftlint --fix` on commit and Conventional Commits validation on commit messages (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `build:`, `ci:`, `perf:`, `style:`, `revert:`).

## Status

Hard-gated in CI (must pass): `swift build` + `swift test`, `xcodebuild` for iOS and macOS, `swiftlint --strict`.

Informational only (work-in-progress): `xcodebuild` for tvOS and watchOS, Periphery dead-code scan. Several files still need `#if os(...)` guards before tvOS/watchOS can be hard-gated — tracked in `TODOS.md`.

The test suite is intentionally narrow at this stage (foundation utilities have full coverage; UI/Manager code is mostly uncovered). Treat green tests as evidence the foundation layer works, not that every helper is correct.

## Conventions

- New code goes into the appropriate target:
  - **`Sources/MatrixSwiftBaseCore/`** if it doesn't import SwiftUI / UIKit / AppKit / PhotosUI / MessageUI.
  - **`Sources/MatrixSwiftBaseUI/`** otherwise. UI code may `import MatrixSwiftBaseCore`; Core must never reference UI.
- Helpers: `<Topic>Helper.swift` containing `public final class <Topic>Helper { public init() {}; public static func … }`
- Extensions: `<Type>Ext.swift` containing `extension <Type> { … }`
- Multi-platform code: guard platform-specific APIs with `#if canImport(UIKit)` or `#if os(iOS)` etc.
- Commits: Conventional Commits, enforced by the commit-msg hook.

See `CLAUDE.md` for the conventions Claude Code uses when working in this repo, and `TODOS.md` for the active backlog.

## License

[Apache License 2.0](./LICENSE). Copyright 2026 Richard Torcato.
