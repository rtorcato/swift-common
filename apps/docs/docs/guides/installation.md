---
title: Installation
description: Add swift-common to your project via SwiftPM, from Package.swift or Xcode.
---

## Add the package

`swift-common` is distributed as a SwiftPM package via its Git URL. It is not published to a registry; pin to a branch or a release tag.

### Package.swift

```swift
// In your Package.swift `dependencies:` array
.package(url: "https://github.com/rtorcato/swift-common", branch: "main"),
```

Then add one or both products to your target's dependencies:

```swift
// Just the utilities
.product(name: "MatrixSwiftBaseCore", package: "swift-common"),

// Utilities + SwiftUI primitives
.product(name: "MatrixSwiftBaseCore", package: "swift-common"),
.product(name: "MatrixSwiftBaseUI", package: "swift-common"),
```

### Xcode

1. **File → Add Package Dependencies…**
2. Paste `https://github.com/rtorcato/swift-common` in the search field.
3. Select which product(s) to link — `MatrixSwiftBaseCore`, `MatrixSwiftBaseUI`, or both.

## Import

Import only the modules you actually use:

```swift
import MatrixSwiftBaseCore

// only if you need the SwiftUI primitives
import MatrixSwiftBaseUI
```

## Requirements

- **Swift**: 5.7+
- **Xcode**: 14+ (15+ recommended for tvOS/watchOS work)
- **Platforms**: iOS 16+, macOS 13+, tvOS 16+, watchOS 9+ — see the [platform support guide](./platforms.md).

## Pinning to a release

The repo does not currently tag semver releases — vendored consumers track `main`. Tagged releases are planned ([#6](https://github.com/rtorcato/swift-common/issues/6)). Once tags land, pin like:

```swift
.package(url: "https://github.com/rtorcato/swift-common", from: "0.1.0"),
```
