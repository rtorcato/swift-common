---
name: swift-common
description: Use when writing Swift or SwiftUI code in an Apple-platform app that depends on swift-common (MatrixSwiftBaseCore / MatrixSwiftBaseUI) — adding the SwiftPM dependency, picking the Core or UI product, calling helpers, APIClient, Endpoint, or the SwiftUI components.
---

# swift-common

A SwiftPM package of Apple-platform utilities by rtorcato, shipped as two library products. Package name: `swift-common` (repo `rtorcato/swift-common`). Targets iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, Swift 5.9+.

## Add it

```swift
// Package.swift
.package(url: "https://github.com/rtorcato/swift-common", branch: "main"),

// target dependencies — pick only what you use
.product(name: "MatrixSwiftBaseCore", package: "swift-common"),
.product(name: "MatrixSwiftBaseUI", package: "swift-common"),
```

In Xcode: File → Add Package Dependencies…, paste the repo URL, link the product(s) you need. The package is vendored (git URL or local path); it is not published to a registry. Releases are tagged; tags are batched and cut when a milestone closes. Pin a version tag in `Package.swift` so updates are deliberate.

## Pick the product

| Need | Product | Import |
|---|---|---|
| Foundation-only code: helpers, extensions, networking, validation, keychain, logging | `MatrixSwiftBaseCore` | `import MatrixSwiftBaseCore` |
| SwiftUI components, modifiers, shapes, styles, UIKit/AppKit-coupled helpers and managers | `MatrixSwiftBaseUI` | `import MatrixSwiftBaseUI` |

- `MatrixSwiftBaseUI` depends on Core. Importing UI does not re-export Core — `import MatrixSwiftBaseCore` too when you use Core types.
- Core never imports SwiftUI / UIKit / AppKit. It is safe in command-line tools and server-side Swift. Do not link UI just to reach a Core helper.

## Core

Helpers are `public final class FooHelper` with **static** methods — call `MathHelper.clamp(...)`, not an instance.

```swift
import MatrixSwiftBaseCore

let v = MathHelper.clamp(150, min: 0, max: 100)        // 100
try await SleepHelper.milliseconds(250)                // async, throws on cancellation
let token = RandomHelper.string(length: 32)
let chunks = [1, 2, 3, 4, 5].chunked(into: 2)          // [[1,2],[3,4],[5]]
let item = ["a", "b"][safe: 5]                         // nil, no crash
```

Other helpers: `DateHelper`, `CryptoHelper`, `CurrencyHelper`, `JsonHelper`, `MimeTypeHelper`, `RegexHelper`, `StringHelper`, `UnitHelper`, `EnvHelper`, `AsyncHelpers`, `FunctionHelper`. Extensions live in `ArrayExt`, `DateExt`, `DictionaryExt`, `SetExt`, `URLExt`, `BoolExt`. Managers: `KeychainManager`, `LocationManager`. Logging: `AppLogger`. Errors: `AppError`.

Read the helper's source for its exact signature before calling it; do not guess parameter labels.

### Networking

`Endpoint` is a **protocol** (not a generic struct). Conform a type, usually an enum, then send it through `APIClient`.

```swift
import MatrixSwiftBaseCore

struct User: Decodable { let id: Int; let name: String }

enum UsersAPI: Endpoint {
    case me
    case rename(String)

    var path: String {
        switch self {
        case .me: return "/users/me"
        case .rename: return "/users/me/name"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .me: return .get
        case .rename: return .patch
        }
    }
    var body: RequestBody {
        switch self {
        case .me: return .empty
        case .rename(let name): return .json(["name": name])
        }
    }
}

let client = APIClient(baseURL: URL(string: "https://api.example.com")!)
let user: User = try await client.send(UsersAPI.me)
```

- `Endpoint` requires only `path`; `method` (`.get`), `queryItems`, `headers`, `body` (`.empty`) and `baseURL` have defaults.
- `client.send(_:)` returns raw `Data`; `client.send(_:as:)` decodes a `Decodable`.
- `APIClient.init` takes optional `session`, `defaultHeaders`, `decoder`, `encoder`, `interceptor` (async, mutates the `URLRequest`, e.g. to add auth) and `logger`.
- Failures are `NetworkError`: `.invalidURL`, `.invalidResponse`, `.http(statusCode:data:)`, `.decoding`, `.encoding`, `.transport(URLError)`, `.cancelled`, `.unknown`. Switch on it, or use `error.statusCode` for HTTP errors.
- It is a thin `URLSession` client. For multipart, OAuth or heavy interceptor chains, use Alamofire instead.

## UI

```swift
import MatrixSwiftBaseCore
import MatrixSwiftBaseUI
import SwiftUI

struct ContentView: View {
    @StateObject private var theme = SystemThemeManager()
    var body: some View {
        VStack {
            RatingView(rating: 4)
        }
        .preferredColorScheme(theme.getColorScheme())
    }
}
```

Not every type in the UI target is `public` or available on every platform (for example `CopyTextView` is internal and iOS-only, and `CardContainer` has no public initializer). Open the source file and confirm the type is `public` and its `init` is reachable before using it; if it is not, say so rather than inventing a workaround.

Groups: Components (`CardContainer`, `LoadingView`, `FormWrapper`, buttons, panels), Modifiers (`BorderRadiusModifier`, `NumbersOnlyViewModifier`), Shapes (`RoundedCorner`, `Line`), Styles (`RoundedButtonStyle`, `PressableButtonStyle`), Views (`BlurView`, `WebView`, `ResponsiveView`), UI helpers (`AlertHelper`, `HapticsHelper`, `KeyboardHelper`, `ScreenHelper`), managers (`ImageCache`, `SoundManager`, `SystemThemeManager`), and `NetworkState`.

## Platform rules

- Many UI types wrap UIKit or AppKit. Do not assume a type exists on every platform: guard with `#if canImport(UIKit)` / `#if canImport(AppKit)` (prefer `canImport` over `os(iOS)`), or `#if !os(watchOS)`.
- tvOS and watchOS compile checks are informational in this package's CI; iOS and macOS are the hard-gated platforms. Verify other platforms with `xcodebuild -scheme MatrixSwiftBaseUI -destination 'generic/platform=<platform>' build`.
- `swift build` and `swift test` only cover the host platform.

## Don't

- Don't use `Endpoint<T>` or `HttpMethod`; the real names are the `Endpoint` protocol and `HTTPMethod`.
- Don't add stdlib-extension sugar here (`String+`, `View+`) — use SwifterSwift. The package is an application-utility layer, not a stdlib extension library.
- Don't put SwiftUI/UIKit/AppKit imports in Core, or Core types that reference UI.
- Don't change the minimum platform versions without a real reason.

## Contributing to swift-common itself

Follow `CLAUDE.md` in the repo: new files go in Core or UI by their imports; helpers are `<Topic>Helper.swift`; extensions `<Type>Ext.swift`; Conventional Commits; SwiftLint config is intentionally lenient. When the public API changes, update `skills/swift-common/SKILL.md` and run `node scripts/sync-agents.mjs` to regenerate `AGENTS.md`.
