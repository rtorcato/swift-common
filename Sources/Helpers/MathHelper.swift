//
//  MathHelper.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-04.
//

import Foundation

public final class MathHelper {

    public init() { }

    /// Constrain a value to the given closed range.
    public static func clamp<T: Comparable>(_ value: T, min lower: T, max upper: T) -> T {
        Swift.min(Swift.max(value, lower), upper)
    }

    /// Linear interpolation between `from` and `to` by amount `t` (typically 0...1).
    public static func lerp<T: BinaryFloatingPoint>(from: T, to: T, t: T) -> T {
        from + (to - from) * t
    }

    /// Map a value from one numeric range to another.
    public static func mapRange<T: BinaryFloatingPoint>(_ value: T, fromMin: T, fromMax: T, toMin: T, toMax: T) -> T {
        guard fromMax != fromMin else { return toMin }
        return toMin + (value - fromMin) * (toMax - toMin) / (fromMax - fromMin)
    }

    /// Round a value to the given number of decimal places.
    public static func roundedTo(_ value: Double, places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (value * divisor).rounded() / divisor
    }

    /// Convert degrees to radians.
    public static func degreesToRadians(_ degrees: Double) -> Double {
        degrees * .pi / 180.0
    }

    /// Convert radians to degrees.
    public static func radiansToDegrees(_ radians: Double) -> Double {
        radians * 180.0 / .pi
    }
}
