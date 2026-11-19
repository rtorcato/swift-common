//
//  NumberHelper.swift
//  MatrixSwiftBase
//
//  Parsing and formatting numbers via Foundation's NumberFormatter.
//  Math (lerp, rounding, angle conversion) lives in MathHelper; `clamp` here
//  forwards to `MathHelper.clamp` so both entry points behave the same.
//

import Foundation

public final class NumberHelper: Sendable {

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
    /// Returns nil when the value is out of `Int` range.
    public static func int(from string: String, locale: Locale = .current) -> Int? {
        guard let value = double(from: string, locale: locale), value.isFinite else { return nil }
        return Int(exactly: value.rounded(.towardZero))
    }

    /// Parse a locale-aware numeric string into a `Decimal`, keeping full
    /// base-10 precision (use this for money and other exact values).
    public static func decimal(from string: String, locale: Locale = .current) -> Decimal? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        return (formatter.number(from: string) as? NSDecimalNumber)?.decimalValue
    }

    // MARK: - Validation

    /// True if `string` is a whole number such as `"42"`, `"-7"` or `"+3"`.
    /// Set `allowSigned` to false to accept only unsigned digits.
    public static func isInteger(_ string: String, allowSigned: Bool = true) -> Bool {
        var digits = Substring(string)
        if allowSigned, let first = digits.first, first == "-" || first == "+" {
            digits = digits.dropFirst()
        }
        return !digits.isEmpty && digits.allSatisfy { $0.isASCII && $0.isNumber }
    }

    /// True if `string` is a plain decimal number such as `"3.14"`, `"-0.5"` or `"10"`,
    /// using `locale`'s decimal separator. Grouping separators are not accepted.
    public static func isDecimal(_ string: String, allowSigned: Bool = true, locale: Locale = .current) -> Bool {
        var body = Substring(string)
        if allowSigned, let first = body.first, first == "-" || first == "+" {
            body = body.dropFirst()
        }
        let parts = body.components(separatedBy: locale.decimalSeparator ?? ".")
        guard parts.count <= 2, parts.contains(where: { !$0.isEmpty }) else { return false }
        return parts.allSatisfy { $0.allSatisfy { $0.isASCII && $0.isNumber } }
            && !(parts.count == 2 && parts[1].isEmpty)
    }

    // MARK: - Clamping

    /// Clamp `value` to `range`. Forwards to `MathHelper.clamp`.
    public static func clamp<T: Comparable>(_ value: T, to range: ClosedRange<T>) -> T {
        MathHelper.clamp(value, min: range.lowerBound, max: range.upperBound)
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

    /// Format a `Decimal` as a decimal string without going through `Double`.
    public static func decimal(_ value: Decimal, fractionDigits: Int? = nil, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        if let fractionDigits {
            formatter.minimumFractionDigits = fractionDigits
            formatter.maximumFractionDigits = fractionDigits
        }
        return formatter.string(from: value as NSDecimalNumber) ?? "\(value)"
    }

    /// Format with compact notation, e.g. `1_200` → `"1.2K"`, `3_400_000` → `"3.4M"`.
    public static func compact(_ value: Double, locale: Locale = .current) -> String {
        value.formatted(.number.notation(.compactName).locale(locale))
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
