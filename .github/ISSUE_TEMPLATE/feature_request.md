---
name: Feature request
about: Propose a new helper, extension, or API
title: ""
labels: enhancement
assignees: ""
---

## Use case

What problem does this solve? Who needs it and when?

## Proposed API

Sketch the signature(s) and which target it belongs in (Core / UI).

```swift
// e.g.
public extension Array { func compactNonNil<Wrapped>() -> [Wrapped] where Element == Wrapped? }
```

## Alternatives considered

Existing helpers, a stdlib option, or a third-party library (SwifterSwift,
Alamofire, etc.) that already covers this.

## Additional context

Anything else relevant.
