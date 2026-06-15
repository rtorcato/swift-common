## [0.2.0](https://github.com/rtorcato/swift-common/compare/v0.1.0...v0.2.0) (2026-06-15)

### Features

* bump swift-tools-version to 5.9 (closes [#12](https://github.com/rtorcato/swift-common/issues/12)) ([13a22a8](https://github.com/rtorcato/swift-common/commit/13a22a827be3fb8ca70d5efd17929dcbfd1135a7))

# Changelog

All notable changes to this project will be documented here. This file is
maintained automatically by [semantic-release](https://semantic-release.gitbook.io/);
entries below `0.1.0` were curated by hand.

## 0.1.0 - 2026-06-15

Initial public release.

- Two SwiftPM products: `MatrixSwiftBaseCore` (pure Foundation) and `MatrixSwiftBaseUI` (SwiftUI).
- Cross-platform support: iOS 16+, macOS 13+, tvOS 16+, watchOS 9+ (all hard-gated in CI).
- Apache-2.0 license.
- Docusaurus documentation at <https://rtorcato.github.io/swift-common/>.
- Scope framing in README and docs: managers, networking, validation, SwiftUI primitives — stdlib extensions deferred to SwifterSwift.
