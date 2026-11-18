# Changelog

## 0.3.0 - 2026-10-21

### Features

* add in-repo AI skill (Claude marketplace + AGENTS.md) and docs install ([#79](https://github.com/rtorcato/swift-common/issues/79)) ([d69b7f1](https://github.com/rtorcato/swift-common/commit/d69b7f15f5e995fb9c72461d84270bfb01db7b23)), closes [#40](https://github.com/rtorcato/swift-common/issues/40)
* **concurrency:** Sendable audit and strict concurrency checking ([#81](https://github.com/rtorcato/swift-common/issues/81)) ([89dea20](https://github.com/rtorcato/swift-common/commit/89dea2039f213757173b1da7973a3ebcd443c8dc)), closes [#14](https://github.com/rtorcato/swift-common/issues/14)
* **lottie:** isolate Lottie into a MatrixSwiftBaseLottie product ([#83](https://github.com/rtorcato/swift-common/issues/83)) ([97ea66b](https://github.com/rtorcato/swift-common/commit/97ea66b70d21a17d574de5eb5d7ad19c50e8df3f)), closes [#81](https://github.com/rtorcato/swift-common/issues/81) [#11](https://github.com/rtorcato/swift-common/issues/11) [#11](https://github.com/rtorcato/swift-common/issues/11)

### Bug Fixes

* **core:** KeychainManager.getPassword threw on success; add Manager tests ([#80](https://github.com/rtorcato/swift-common/issues/80)) ([baa595a](https://github.com/rtorcato/swift-common/commit/baa595a23b8bb3f70793e702e4c4b4ddcc9f7aa7)), closes [#13](https://github.com/rtorcato/swift-common/issues/13)

## 0.2.0 - 2026-06-15

### Features

* bump swift-tools-version to 5.9 (closes [#12](https://github.com/rtorcato/swift-common/issues/12)) ([13a22a8](https://github.com/rtorcato/swift-common/commit/13a22a827be3fb8ca70d5efd17929dcbfd1135a7))

## 0.1.0 - 2026-06-15

Initial public release.

- Two SwiftPM products: `MatrixSwiftBaseCore` (pure Foundation) and `MatrixSwiftBaseUI` (SwiftUI).
- Cross-platform support: iOS 16+, macOS 13+, tvOS 16+, watchOS 9+ (all hard-gated in CI).
- Apache-2.0 license.
- Docusaurus documentation at <https://rtorcato.github.io/swift-common/>.
- Scope framing in README and docs: managers, networking, validation, SwiftUI primitives — stdlib extensions deferred to SwifterSwift.
