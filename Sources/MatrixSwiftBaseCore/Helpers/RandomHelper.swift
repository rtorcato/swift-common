//
//  RandomHelper.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-04.
//

import Foundation

public final class RandomHelper {

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
}
