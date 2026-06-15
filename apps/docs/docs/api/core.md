---
title: Core API overview
description: MatrixSwiftBaseCore — Foundation-only utilities, no SwiftUI / UIKit / AppKit. Safe in CLI tools and server-side Swift.
---

`MatrixSwiftBaseCore` ships Foundation-only utilities. Import once and reach for the relevant module.

```swift
import MatrixSwiftBaseCore
```

> Full type signatures will live in the DocC reference once that lands ([#10](https://github.com/rtorcato/swift-common/issues/10)). This page is the narrative overview with code samples.

## Helpers

Stateless `public final class FooHelper` containers with static methods.

| Helper | Purpose |
|---|---|
| `AsyncHelpers` | Common async / await patterns |
| `BundleHelper` | App / framework bundle introspection |
| `CoreDataHelper` | Lightweight Core Data setup helpers |
| `CryptoHelper` | Hashing, key derivation (CryptoKit) |
| `CurrencyHelper` | Currency formatting via `NumberFormatter` |
| `DateHelper` | Date construction, formatting, arithmetic |
| `DoubleHelper` | Rounding, formatting, conversions |
| `EmojiHelper` | Emoji utilities |
| `EnvHelper` | Read environment variables / process info |
| `FaceIdHelper` | Biometric availability checks |
| `FunctionHelper` | Debounce / throttle / memoize-style wrappers |
| `GeometryHelper` | Geometric calculations (no UIKit) |
| `JsonHelper` | JSON encode/decode convenience |
| `MathHelper` | `clamp`, `lerp`, common math |
| `MimeTypeHelper` | Filename ↔ MIME type via `UniformTypeIdentifiers` |
| `RandomHelper` | Random numbers, strings, picks |
| `RegexHelper` | Regex compile-and-test helpers |
| `SleepHelper` | Sleep in ms / seconds (async-safe) |
| `SoundHelper` | Audio file utilities |
| `StringHelper` | Common string transforms |
| `ThreadHelper` | Thread / queue introspection |
| `UnitHelper` | Unit conversions |

### Example

```swift
let clamped = MathHelper.clamp(150, min: 0, max: 100) // 100
try await SleepHelper.milliseconds(250)
let token = RandomHelper.string(length: 32)
let mime  = MimeTypeHelper.mimeType(forFilename: "doc.pdf") // "application/pdf"
```

## Extensions

Drop-in additions to Foundation types.

| File | What it adds |
|---|---|
| `ArrayExt` | `chunked(into:)`, `subscript(safe:)`, etc. |
| `BoolExt` | Display / negation helpers |
| `DateExt` | Component access, formatting shortcuts |
| `DictionaryExt` | Merge, transform helpers |
| `SetExt` | `toggle(_:)`, set algebra sugar |
| `URLExt` | Query-item helpers, common transforms |

### Example

```swift
let chunks = [1, 2, 3, 4, 5].chunked(into: 2) // [[1,2],[3,4],[5]]
let safe   = ["a", "b"][safe: 5]              // nil

var set: Set = [1, 2]
set.toggle(3) // [1, 2, 3]
set.toggle(1) // [2, 3]
```

## Networking

Modern async/await HTTP client built on `URLSession`.

| Type | Purpose |
|---|---|
| `APIClient` | Send `Endpoint` requests, decode responses |
| `Endpoint` | Type-safe request description (path, method, headers, body) |
| `HttpMethod` | `GET` / `POST` / `PUT` / `PATCH` / `DELETE` |
| `RequestBody` | JSON / form / multipart payloads |
| `NetworkError` | Typed errors (no `Error` casts at call site) |

### Example

```swift
struct User: Decodable { let id: Int; let name: String }

let endpoint = Endpoint<User>(
    path: "/users/me",
    method: .get
)

let client = APIClient(baseURL: URL(string: "https://api.example.com")!)
let user = try await client.send(endpoint)
```

Retry policy is on the roadmap (`TODOS.md`).

## Concurrency

| Type | Purpose |
|---|---|
| `IntervalHelper` | Repeating timer wrappers compatible with structured concurrency |

## Errors / Logging

| Type | Purpose |
|---|---|
| `AppError` | Typed application-level error enum |
| `AppLogger` | `os.Logger` wrapper with category + level helpers |

## Managers

Stateful objects that aren't UI but still hold long-lived state.

| Manager | Purpose |
|---|---|
| `KeychainManager` | Save / load / delete to the system keychain |
| `LocationManager` | `CLLocationManager` wrapper |

## Models

Value-typed enums / structs used across the library.

| Model | Purpose |
|---|---|
| `ImageFileTypes` | `.jpg` / `.png` / `.heic` / etc. |
| `LocalNotification` | Notification payload struct |
| `SoundFileTypes` | `.mp3` / `.wav` / `.caf` / etc. |
| `SystemThemes` | `.light` / `.dark` / `.system` |

## Validations

| Type | Purpose |
|---|---|
| `Validations` | Email / phone / URL / general string validators. Will be expanded into a `Validator<T>` protocol layer per [TODOS.md](https://github.com/rtorcato/swift-common/blob/main/TODOS.md). |
