---
title: Platform support
description: Which Apple platforms swift-common supports and what's verified in CI.
---

## Supported platforms

| Platform | Minimum version | Status |
|---|---|---|
| iOS | 16.0 | ✅ Hard-gated in CI (`xcodebuild build`) |
| macOS | 13.0 | ✅ Hard-gated in CI (`xcodebuild build`) |
| tvOS | 16.0 | ⚠️ Informational only — some files still need `#if os(...)` guards. Tracked in `TODOS.md`. |
| watchOS | 9.0 | ⚠️ Informational only — same as tvOS. |
| visionOS | (untested) | Likely works via `canImport(UIKit)` paths; no CI coverage. |
| Mac Catalyst | (untested) | Likely works; no CI coverage. |

"Hard-gated" means a failure blocks the PR. "Informational only" means the job runs but is allowed to fail while we close the platform-guard gaps.

## What CI verifies

The `ci.yml` workflow runs:

| Job | Required? | What it does |
|---|---|---|
| `swift build` + `swift test` | ✅ | Host-platform build + tests |
| `swiftlint --strict` | ✅ | Lint with strict mode |
| `xcodebuild iOS` | ✅ | Compile for iOS |
| `xcodebuild macOS` | ✅ | Compile for macOS |
| `xcodebuild tvOS` | ⚠️ | Compile for tvOS (informational) |
| `xcodebuild watchOS` | ⚠️ | Compile for watchOS (informational) |
| Periphery dead-code | ⚠️ | Informational dead-code scan |
| CodeQL | ✅ | Security analysis |

## Verifying locally

```bash
# Host platform only
swift build
swift test

# All Apple platforms (slow — uses xcodebuild)
xcodebuild -scheme MatrixSwiftBaseUI -destination 'generic/platform=iOS' build
xcodebuild -scheme MatrixSwiftBaseUI -destination 'generic/platform=macOS' build
xcodebuild -scheme MatrixSwiftBaseUI -destination 'generic/platform=tvOS' build
xcodebuild -scheme MatrixSwiftBaseUI -destination 'generic/platform=watchOS' build
```

If you use Claude Code, the `/verify-platforms` skill runs all four platforms and reports a clean diff of what passed / failed.

## When to bump the minimums

iOS 16 / macOS 13 / tvOS 16 / watchOS 9 are the current minimums (set in `Package.swift`). Bumping requires:

1. A non-trivial reason — e.g. adopting a SwiftUI API that needs iOS 17.
2. A note in the next release's changelog.
3. Updating this page.

Currently no plans to bump.
