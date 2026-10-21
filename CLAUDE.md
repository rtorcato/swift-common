# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Swift Package library of cross-platform Apple utilities. Vendored (consumers depend on the git URL or local path); not published to a registry. Releases are tagged; tags are batched and cut when a milestone closes.

Ships three SwiftPM library products:

- **`MatrixSwiftBaseCore`** — pure Foundation utilities. Never imports SwiftUI / UIKit / AppKit. Sources under `Sources/MatrixSwiftBaseCore/`.
- **`MatrixSwiftBaseUI`** — SwiftUI components and SwiftUI-coupled helpers. Depends on Core. Sources under `Sources/MatrixSwiftBaseUI/`.
- **`MatrixSwiftBaseLottie`** — Lottie animation views, isolated so only consumers who link it pull in the Lottie dependency. Sources under `Sources/MatrixSwiftBaseLottie/`. Anything that imports Lottie goes here, never in UI.

When adding a new file, decide which target it belongs to by its imports: if it needs SwiftUI / UIKit / AppKit / PhotosUI / MessageUI, it goes in UI; otherwise Core. UI code may `import MatrixSwiftBaseCore`; Core must never reference UI types.

## Platforms

Must compile on **iOS 16+, macOS 13+, tvOS 16+, watchOS 9+**. When using platform-specific APIs (UIKit, AppKit, WatchKit, etc.), guard with `#if os(iOS)` / `#if canImport(UIKit)` etc. Do not assume UIKit-only or AppKit-only.

Primary workflow is **Xcode**, not the CLI. `swift build` only builds for the host platform — to verify multi-platform compatibility use `xcodebuild` per destination (or run the `/verify-platforms` skill).

## Tests

The test suite is sparse and does not cover most code. **A green `swift test` is not proof of correctness.** When making non-trivial changes, verify by compiling for each platform and, where possible, exercising the change in Xcode.

## Linting

SwiftLint config is in `.swiftlint.yml` and is intentionally lenient — many rules are disabled (`force_unwrapping`, `line_length`, `identifier_name`, `cyclomatic_complexity`, etc.). Do not re-enable disabled rules without asking. `file_length` warns at 500 lines, errors at 1200.

## Package.swift

Many dependencies and target products are commented out (Lottie, SDWebImage, SDWebImageSVGCoder, SVGView, PopupView). When editing `Package.swift`, remove obviously dead commented lines you touch — but don't do a sweeping cleanup unprompted.

## Conventions

- Source layout: feature-grouped under `Sources/MatrixSwiftBaseCore/` and `Sources/MatrixSwiftBaseUI/` (Components, Extensions, Helpers, Managers, Models, Networking, State, Styles, Views, etc.).
- Tests live in `Tests/MatrixSwiftBaseCoreTests/` and `Tests/MatrixSwiftBaseUITests/`.
- Commit style is loose — short imperative messages are fine.
