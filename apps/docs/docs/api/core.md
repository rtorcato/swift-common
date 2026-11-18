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
| `DateHelper` | ISO-8601, relative time, time-zone formatting, business-day math, RFC 822 parsing |
| `DoubleHelper` | Rounding, formatting, conversions |
| `EmojiHelper` | Emoji utilities |
| `EnvHelper` | Read environment variables / process info |
| `FaceIdHelper` | Biometric availability checks |
| `FunctionHelper` | Debounce / throttle / memoize-style wrappers |
| `GeometryHelper` | Geometric calculations (no UIKit) |
| `JsonHelper` | JSON encode/decode convenience |
| `MathHelper` | `clamp`, `lerp`, common math |
| `NumberHelper` | Locale-aware parsing (`Int`/`Double`/`Decimal`), decimal/percent/scientific/compact formatting, numeric validation, clamping |
| `MimeTypeHelper` | Filename ↔ MIME type via `UniformTypeIdentifiers` |
| `RandomHelper` | Random numbers, strings, picks; sampling with or without replacement; `SeededGenerator` for reproducible results |
| `RegexHelper` | Regex compile-and-test helpers |
| `SleepHelper` | Sleep in ms / seconds (async-safe) |
| `SoundHelper` | Audio file utilities |
| `SystemInfoHelper` | OS name and version, device model, locale, bundle ID, app version and build |
| `StringHelper` | Common string transforms |
| `ThreadHelper` | Thread / queue introspection |
| `TimeZoneHelper` | Time-zone lookup, DST-aware offsets, wall-clock conversion between zones |
| `UnitHelper` | Unit conversions |

### Example

```swift
let clamped = MathHelper.clamp(150, min: 0, max: 100) // 100
try await SleepHelper.milliseconds(250)
let token = RandomHelper.string(length: 32)
let mime  = MimeTypeHelper.mimeType(forFilename: "doc.pdf") // "application/pdf"
let short = NumberHelper.compact(1_200)                       // "1.2K"
let due   = DateHelper.addingBusinessDays(3, to: Date())      // skips weekends
var rng   = SeededGenerator(seed: 42)
let picks = [1, 2, 3, 4, 5].randomElements(count: 2, using: &rng) // same every run
```

## Extensions

Drop-in additions to Foundation types.

| File | What it adds |
|---|---|
| `ArrayExt` | `chunked(into:)`, `subscript(safe:)`, `compactNonNil()`, etc. |
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
| `HTTPMethod` | `GET` / `POST` / `PUT` / `PATCH` / `DELETE` / … |
| `RequestBody` | Empty / raw data / JSON / form payloads |
| `NetworkError` | Typed errors (no `Error` casts at call site) |

### Example

```swift
import Foundation
import MatrixSwiftBaseCore

struct User: Decodable { let id: Int; let name: String }

// `Endpoint` is a protocol: conform a type (often an enum) to it.
// Only `path` is required; `method` defaults to `.get`.
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
let user = try await client.send(UsersAPI.me, as: User.self)
```

Retry policy is on the roadmap (`TODOS.md`).

## Concurrency

| Type | Purpose |
|---|---|
| `IntervalHelper` | Repeating timer wrappers compatible with structured concurrency |

## Events

| Type | Purpose |
|---|---|
| `EventBus` | Typed, Combine-backed event bus with `on` / `off` / `emit`; replaces stringly-typed `NotificationCenter` wrappers |
| `Event` | `Sendable` marker protocol for event types |

### Example

```swift
struct UserLoggedIn: Event { let userID: String }

let token = EventBus.shared.on(UserLoggedIn.self) { event in
    print(event.userID)          // runs on the emitter's thread
}
EventBus.shared.emit(UserLoggedIn(userID: "abc"))
EventBus.shared.off(token)

// Or compose with Combine, e.g. to deliver on the main queue:
let cancellable = EventBus.shared.publisher(for: UserLoggedIn.self)
    .receive(on: DispatchQueue.main)
    .sink { print($0.userID) }
```

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

## Type aliases

Shared aliases in `Types/Aliases.swift`.

| Alias | Definition |
|---|---|
| `JSONDictionary` | `[String: Any]` |
| `JSONArray` | `[Any]` |
| `Completion<T>` | `(Result<T, Error>) -> Void` |
| `VoidCompletion` | `() -> Void` |
| `Bytes` | `[UInt8]` |

## Validations

| Type | Purpose |
|---|---|
| `Validator<Value>` | Protocol for composable rules: `.and(_:)`, `.or(_:)`, `.negated()`, `.asRule()`; works as `some` / `any Validator<String>` |
| `ValidationRule<Value>` | Closure-backed validator, composable with `&&`, `\|\|` and `!` |
| `EmailValidator` / `PhoneValidator` / `URLValidator` | Wrap the existing `Validations` checks |
| `CreditCardValidator` | Luhn checksum, 12–19 digits, spaces and dashes allowed |
| `PasswordValidator` | Configurable `Requirements`: length, upper, lower, digit, special character |
| `PostalCodeValidator` | Per-region patterns (US, CA, GB, DE, FR, IT, ES, AU, NL, JP, IN, and more), permissive fallback |
| `Validations` | The original static entry points; still supported |

### Example

```swift
let password = PasswordValidator(requirements: .init(minLength: 12, requiresSpecialCharacter: true))
password.isValid("Correct-Horse-9")                    // true

let signup = EmailValidator().and(ValidationRule { !$0.hasSuffix("@example.com") })
signup.isValid("me@torcato.dev")                       // true

PostalCodeValidator(regionCode: "CA").isValid("K1A 0B1") // true
CreditCardValidator().isValid("4111 1111 1111 1111")   // true
```
