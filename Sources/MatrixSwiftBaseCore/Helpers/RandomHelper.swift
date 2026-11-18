//
//  RandomHelper.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-04.
//

import Foundation

public final class RandomHelper: Sendable {

    public init() { }

    /// Random integer in the given closed range.
    public static func int(in range: ClosedRange<Int>) -> Int {
        Int.random(in: range)
    }

    /// Random double in the given closed range.
    public static func double(in range: ClosedRange<Double>) -> Double {
        Double.random(in: range)
    }

    /// Random boolean.
    public static func bool() -> Bool {
        Bool.random()
    }

    /// Random element from a collection. Returns nil if the collection is empty.
    public static func element<T>(from collection: [T]) -> T? {
        collection.randomElement()
    }

    /// Random alphanumeric string of the given length. Returns empty string for length <= 0.
    public static func string(length: Int) -> String {
        guard length > 0 else { return "" }
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        return String((0..<length).compactMap { _ in chars.randomElement() })
    }

    /// Up to `count` distinct random elements, sampled without replacement.
    /// Returns fewer elements if the collection is smaller than `count`.
    public static func elements<T>(from collection: [T], count: Int) -> [T] {
        guard count > 0 else { return [] }
        return Array(collection.shuffled().prefix(count))
    }

    /// Sampling without replacement using a caller-supplied generator
    /// (e.g. `SeededGenerator`) for reproducible results.
    public static func elements<T>(from collection: [T], count: Int, using generator: inout some RandomNumberGenerator) -> [T] {
        guard count > 0 else { return [] }
        return Array(collection.shuffled(using: &generator).prefix(count))
    }

    /// Exactly `count` random elements sampled with replacement, so items can repeat
    /// (like lodash `sampleSize` on a pool you draw from repeatedly).
    /// Returns an empty array when the collection is empty or `count <= 0`.
    public static func samples<T>(from collection: [T], count: Int) -> [T] {
        var generator = SystemRandomNumberGenerator()
        return samples(from: collection, count: count, using: &generator)
    }

    /// Sampling with replacement using a caller-supplied generator for reproducible results.
    public static func samples<T>(from collection: [T], count: Int, using generator: inout some RandomNumberGenerator) -> [T] {
        guard count > 0, !collection.isEmpty else { return [] }
        return (0..<count).map { _ in collection[Int.random(in: collection.indices, using: &generator)] }
    }
}

public extension Collection {
    /// `count` random elements. Without replacement (the default) the result has
    /// no repeated positions and is capped at the collection's size; with
    /// replacement it always has `count` elements (empty if the collection is empty).
    func randomElements(count: Int, withReplacement: Bool = false) -> [Element] {
        var generator = SystemRandomNumberGenerator()
        return randomElements(count: count, withReplacement: withReplacement, using: &generator)
    }

    /// Seeded variant of `randomElements(count:withReplacement:)`.
    func randomElements(count: Int, withReplacement: Bool = false, using generator: inout some RandomNumberGenerator) -> [Element] {
        let pool = Array(self)
        return withReplacement
            ? RandomHelper.samples(from: pool, count: count, using: &generator)
            : RandomHelper.elements(from: pool, count: count, using: &generator)
    }
}

/// A seedable, deterministic RNG (SplitMix64): the same seed always yields the
/// same sequence. Use for reproducible tests and sampling.
///
/// - Note: Not cryptographically secure. For secrets use `SystemRandomNumberGenerator`.
public struct SeededGenerator: RandomNumberGenerator, Sendable {

    private var state: UInt64

    public init(seed: UInt64) {
        state = seed
    }

    public mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}
