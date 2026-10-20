//
//  NumberHelper.swift
//  MatrixSwiftBase
//
//  Parsing and formatting numbers via Foundation's NumberFormatter.
//  Math (clamp, lerp, rounding, angle conversion) lives in MathHelper — this
//  helper deliberately does not duplicate it.
//

import Foundation

public final class NumberHelper {

    public init() { }

    // MARK: - Parsing

    /// Parse a locale-aware numeric string into a Double. Returns nil if it isn't a number.
    public static func double(from string: String, locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue
    }

    /// Parse a locale-aware numeric string into an Int (truncating any fraction).
    public static func int(from string: String, locale: Locale = .current) -> Int? {
        double(from: string, locale: locale).map { Int($0) }
    }

    // MARK: - Formatting

    /// Format as a decimal string, optionally fixing the fraction-digit count.
    public static func decimal(_ value: Double, fractionDigits: Int? = nil, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        if let fractionDigits {
            formatter.minimumFractionDigits = fractionDigits
            formatter.maximumFractionDigits = fractionDigits
        }
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    /// Format as a percent string. `value` is a ratio: `0.42` → `"42%"`.
    public static func percent(_ value: Double, fractionDigits: Int = 0, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: value)) ?? "\(value * 100)%"
    }

    /// Format in scientific notation, e.g. `1234.0` → `"1.234E3"`.
    public static func scientific(_ value: Double, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .scientific
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
