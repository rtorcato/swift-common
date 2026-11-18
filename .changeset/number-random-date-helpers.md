---
"@rtorcato/swift-common": minor
---

Add `NumberHelper` (locale-aware `Int`/`Double`/`Decimal` parsing, decimal/percent/scientific/compact formatting, numeric-string validation, `clamp(_:to:)`) and `TimeZoneHelper` (lookup, DST-aware offsets, wall-clock conversion). `DateHelper` is now public and adds ISO-8601 round-trips, relative time, time-zone-aware formatting and business-day math; its formatters are no longer shared across threads. `RandomHelper` adds sampling with replacement, `Collection.randomElements(count:withReplacement:)`, and `SeededGenerator` for reproducible results.
