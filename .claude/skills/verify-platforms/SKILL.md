---
name: verify-platforms
description: Compile MatrixSwiftBase for every supported Apple platform (iOS, macOS, tvOS, watchOS) and report which targets build cleanly and which fail. Use when the user asks to verify cross-platform compatibility, before suggesting a non-trivial change is "done", or whenever code uses platform-conditional APIs.
---

# Verify platforms

Compile the package for each supported destination and report results. `swift build` only covers the host — this skill catches breakage on the other platforms before Xcode does.

## Steps

Run each command from the repo root and capture exit status + last ~20 lines of stderr on failure:

```bash
xcodebuild -scheme MatrixSwiftBase -destination 'generic/platform=iOS' build -quiet
xcodebuild -scheme MatrixSwiftBase -destination 'generic/platform=macOS' build -quiet
xcodebuild -scheme MatrixSwiftBase -destination 'generic/platform=tvOS' build -quiet
xcodebuild -scheme MatrixSwiftBase -destination 'generic/platform=watchOS' build -quiet
```

Run them sequentially (xcodebuild contention is unpredictable in parallel). If a scheme is missing, try `-list` to discover the actual scheme name and adjust.

## Report format

Print a compact table:

```
iOS      ✓
macOS    ✓
tvOS     ✗  (error: 'UIView' is unavailable in tvOS)
watchOS  ✗  (error: ...)
```

For each failure, include the first compiler error line so the user can jump straight to the offending file. Do not paste full xcodebuild logs.

## When NOT to use

- Pure refactor inside platform-agnostic code (extensions on `String`, generic models, etc.) with no `#if os(...)` involved.
- Tiny doc-only or comment-only edits.
