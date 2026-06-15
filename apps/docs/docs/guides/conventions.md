---
title: Conventions
description: Target placement rules, file naming, and platform-guard patterns for swift-common.
---

The conventions below are enforced by code review, not tooling. If you add code that breaks them, expect a follow-up PR.

## Target placement

Every new file lives in exactly one target:

| File needs… | Target | Folder |
|---|---|---|
| Only Foundation (or pure Swift) | `MatrixSwiftBaseCore` | `Sources/MatrixSwiftBaseCore/` |
| SwiftUI / UIKit / AppKit / PhotosUI / MessageUI / Lottie | `MatrixSwiftBaseUI` | `Sources/MatrixSwiftBaseUI/` |

**Rules:**

- UI code may `import MatrixSwiftBaseCore`. Core code **must never** reference UI types.
- If a helper has a pure-Foundation core and a SwiftUI sugar wrapper, split them: put the Foundation part in Core, the SwiftUI sugar in UI.
- A consumer importing only Core never compiles or links any UI code. Don't break this invariant.

## File naming

| Kind | Pattern | Example |
|---|---|---|
| Helper | `<Topic>Helper.swift` | `DateHelper.swift`, `CryptoHelper.swift` |
| Extension | `<Type>Ext.swift` | `ArrayExt.swift`, `DateExt.swift` |
| Manager (stateful, often `@MainActor` / `ObservableObject`) | `<Name>Manager.swift` | `KeychainManager.swift` |
| SwiftUI component | descriptive PascalCase | `CardContainer.swift`, `LoadingView.swift` |
| ViewModifier | `<Name>Modifier.swift` | `BorderRadiusModifier.swift` |
| Style | `<Name>Style.swift` | `PressableButtonStyle.swift` |

## Helper class shape

```swift
public final class FooHelper {
    public init() {}
    public static func bar() { /* … */ }
}
```

Static methods unless state is needed. The `public init() {}` is there so consumers can mock with subclasses if they need to.

## Platform guards

The library targets four platforms. When using an API that doesn't exist everywhere, guard:

```swift
#if canImport(UIKit)
import UIKit
// UIKit-specific code
#elseif canImport(AppKit)
import AppKit
// AppKit-specific code
#endif

#if os(iOS) || os(tvOS) || os(visionOS)
// iOS-family only
#endif

#if !os(watchOS)
// Everything except watchOS
#endif
```

Prefer `canImport(UIKit)` over `os(iOS)` when you only need the framework to be present (matters for Mac Catalyst and visionOS).

## Commit style

Conventional Commits, enforced by the pre-commit hook (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, `build:`, `ci:`, `perf:`, `style:`, `revert:`).

One-time hook install:

```bash
brew install pre-commit
pre-commit install --install-hooks
```

This wires up `swiftlint --fix` on commit and commit-message validation.

## Linting

`.swiftlint.yml` is intentionally lenient — many rules disabled (`force_unwrapping`, `line_length`, `identifier_name`, `cyclomatic_complexity`, etc.). Don't re-enable disabled rules without asking. `file_length` warns at 500 lines, errors at 1200.
