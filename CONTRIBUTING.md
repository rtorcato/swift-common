# Contributing

Thanks for your interest in `swift-common`. This is a vendored utility library
for Apple platforms; contributions that keep it small, correct, and
cross-platform are very welcome.

## Build and test

```bash
swift build
swift test
```

`swift build`/`swift test` only exercise the **host** platform. To verify the
change compiles everywhere the library ships, build for each Apple platform:

```bash
xcodebuild -scheme MatrixSwiftBase -destination 'generic/platform=iOS'     build
xcodebuild -scheme MatrixSwiftBase -destination 'generic/platform=macOS'   build
xcodebuild -scheme MatrixSwiftBase -destination 'generic/platform=tvOS'    build
xcodebuild -scheme MatrixSwiftBase -destination 'generic/platform=watchOS' build
```

(Claude Code users can run the `/verify-platforms` skill instead.)

## Which target does my code go in?

Decide by imports:

- **`Sources/MatrixSwiftBaseCore/`** — pure Foundation. If it does **not** import
  SwiftUI / UIKit / AppKit / PhotosUI / MessageUI / Lottie, it goes here.
- **`Sources/MatrixSwiftBaseUI/`** — SwiftUI components and SwiftUI-coupled
  helpers. UI code may `import MatrixSwiftBaseCore`; Core must **never** reference
  UI types.

Guard platform-specific APIs with `#if canImport(UIKit)` / `#if os(iOS)` etc. —
the library must compile on iOS 16+, macOS 13+, tvOS 16+, watchOS 9+.

## File naming

- Helpers: `<Topic>Helper.swift` — `public final class <Topic>Helper { public init() {}; public static func … }`
- Extensions: `<Type>Ext.swift` — `extension <Type> { … }`

## Commits

This repo uses [Conventional Commits](https://www.conventionalcommits.org/),
enforced by a commit-msg hook (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`,
`test:`, `build:`, `ci:`, `perf:`, `style:`, `revert:`). Releases are cut
automatically by semantic-release from these messages.

One-time hook setup:

```bash
brew install pre-commit
pre-commit install --install-hooks
```

This also wires up `swiftlint --fix` on commit.

## Pull requests

- CI must pass: `swift build` + `swift test`, `swiftlint --strict`, and
  `xcodebuild` for all four Apple platforms.
- Note the target (Core/UI), which platforms you tested, and whether the change
  is breaking. The PR template prompts for this.
