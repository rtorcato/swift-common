---
"@rtorcato/swift-common": minor
---

Add `SystemInfoHelper` (OS name and version, device model including the simulated model on simulators, locale, bundle ID, app version and build) and `EventBus`, a typed Combine-backed event bus with `on` / `off` / `emit` and a `publisher(for:)` for Combine pipelines. Events are `Sendable` and handlers `@Sendable`, so the shared bus is safe to use from any thread.
