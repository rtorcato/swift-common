---
title: Scope
description: What swift-common covers, and what it deliberately leaves to the wider Swift ecosystem.
sidebar_position: 1
---

# Scope

`swift-common` is the **application-utility layer** — managers, helpers,
networking, validation, and SwiftUI components reused across iOS / macOS apps.
It is **not** a stdlib-extension library, and it does not try to compete with
the popular community packages listed below.

## Belongs here

- **Stateful managers** with a unified API: `KeychainManager`, `ImageCache`,
  `SystemThemeManager`, `LocationManager`, `BeaconDetector`.
- **Networking** — `APIClient`, `HttpMethod`, `NetworkError` (retry policy
  planned, [#23](https://github.com/rtorcato/swift-common/issues/23)).
- **Validation rules** and **domain helpers** — `CurrencyHelper`,
  `CryptoHelper`, `JsonHelper`, `DateHelper`, `MathHelper`, etc.
- **SwiftUI primitives** tuned to project conventions — components, containers,
  modifiers, shapes, styles.

## Deliberately left to the ecosystem

| Need | Use |
| --- | --- |
| Stdlib extensions (`Array+`, `String+`, `Date+`, `View+`) | [SwifterSwift](https://github.com/SwifterSwift/SwifterSwift) |
| Heavy networking (interceptors, multipart, OAuth) | [Alamofire](https://github.com/Alamofire/Alamofire) |
| Image loading / caching at scale | [Kingfisher](https://github.com/onevcat/Kingfisher) |
| Typed `UserDefaults` | [Defaults](https://github.com/sindresorhus/Defaults) |
| General SwiftUI extension layer | [SwiftUIX](https://github.com/SwiftUIX/SwiftUIX) |

## Why split this way

The goal is a thin, opinionated wrapper that holds a consistent set of idioms
(logger, error types, async patterns, theming) on top of whatever community
packages already do the heavy lifting. SwifterSwift covers ~30% of what an app
needs from a utility library — the stdlib-extension layer. `swift-common` owns
the layer above it: stateful services, networking, validation, and app-level
SwiftUI primitives.

## Legacy extensions

A handful of small extensions still live in
`Sources/MatrixSwiftBaseCore/Extensions/` (`Array+`, `Set+`, `Bool+`, `Date+`,
`URL+`). These predate the scope decision and will be pruned where SwifterSwift
already provides an equivalent. New extension work should not land here — add
a SwifterSwift dependency in the consuming app instead.

## When to abandon `swift-common`

If you only need stdlib extensions, you don't need this library. Use
SwifterSwift directly. `swift-common` earns its place by owning the manager,
networking, and validation layers — strip those away and there's nothing left
that the community ecosystem doesn't cover better.
