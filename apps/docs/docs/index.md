---
title: swift-common
description: Cross-platform Swift utilities for Apple platforms — Core (pure Foundation) and UI (SwiftUI) products from a single SwiftPM package.
sidebar_position: 0
---

# swift-common

A reusable foundation library for Apple platforms — the Swift counterpart to
[`@rtorcato/js-common`](https://github.com/rtorcato/js-common) and
[`@rtorcato/browser-common`](https://github.com/rtorcato/browser-common). Built on
Foundation and SwiftUI; designed to be added to any iOS / macOS / tvOS / watchOS
app as a SwiftPM dependency.

## Two products, pay-what-you-use

- **`MatrixSwiftBaseCore`** — pure Foundation utilities. No `import SwiftUI` /
  `import UIKit` / `import AppKit`. Safe to depend on from anywhere, including
  command-line tools and server-side Swift.
- **`MatrixSwiftBaseUI`** — SwiftUI components and SwiftUI-coupled helpers.
  Depends on Core.

A consumer depending on just `MatrixSwiftBaseCore` never compiles or links any
UI code — Swift's product isolation gives the same effect as keeping the UI in a
separate repo, without the operational tax.

## Quick example

```swift
import MatrixSwiftBaseCore

// Helpers
let value = MathHelper.clamp(150, min: 0, max: 100)             // 100
try await SleepHelper.milliseconds(250)
let random = RandomHelper.string(length: 16)

// Extensions
let chunks = [1, 2, 3, 4, 5].chunked(into: 2)                   // [[1,2],[3,4],[5]]
let safe = ["a", "b"][safe: 5]                                  // nil
```

```swift
import MatrixSwiftBaseUI

struct ContentView: View {
    @StateObject var theme = SystemThemeManager()
    var body: some View {
        CardContainer {
            Text("Hello, swift-common")
        }
    }
}
```

## Where to next

- [Scope](./guides/scope.md) — what this library covers, and what it intentionally leaves to SwifterSwift, Alamofire, Kingfisher, and friends.
- [Installation](./guides/installation.md) — SPM `Package.swift` snippet and Xcode add-package flow.
- [Conventions](./guides/conventions.md) — target placement rules, file naming, platform guards.
- [Platform support](./guides/platforms.md) — the iOS 16+ / macOS 13+ / tvOS 16+ / watchOS 9+ matrix.
- [Core API overview](./api/core.md) — Helpers, Extensions, Networking, Managers, Models.
- [UI API overview](./api/ui.md) — Components, Modifiers, Shapes, Styles, Views, UI Helpers/Managers.
