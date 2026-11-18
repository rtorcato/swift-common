//
//  Validator.swift
//  MatrixSwiftBase
//
//  A composable, rule-based validation layer. The existing `Validations`
//  static entry points remain valid — these validators build on them and add
//  credit-card (Luhn), configurable password, and per-locale postal-code rules.
//

import Foundation

/// Something that can decide whether a value is valid. The primary associated
/// type lets you write `some Validator<String>` / `any Validator<String>`.
///
///     let signup = EmailValidator().and(ValidationRule { !$0.hasSuffix("@example.com") })
///     signup.isValid("me@torcato.dev")   // true
public protocol Validator<Value>: Sendable {
    associatedtype Value
    func isValid(_ value: Value) -> Bool
}

public extension Validator {
    /// Valid only when both validators pass.
    func and<Other: Validator>(_ other: Other) -> ValidationRule<Value> where Other.Value == Value {
        ValidationRule { self.isValid($0) && other.isValid($0) }
    }

    /// Valid when either validator passes.
    func or<Other: Validator>(_ other: Other) -> ValidationRule<Value> where Other.Value == Value {
        ValidationRule { self.isValid($0) || other.isValid($0) }
    }

    /// Valid when this validator fails.
    func negated() -> ValidationRule<Value> {
        ValidationRule { !self.isValid($0) }
    }

    /// Wrap any validator as a `ValidationRule` so it composes with `&&` / `||` / `!`.
    func asRule() -> ValidationRule<Value> {
        ValidationRule { self.isValid($0) }
    }
}

/// A validator backed by a closure, composable with `&&` / `||` / `!`.
public struct ValidationRule<Value>: Validator {

    private let predicate: @Sendable (Value) -> Bool

    public init(_ predicate: @escaping @Sendable (Value) -> Bool) {
        self.predicate = predicate
    }

    public func isValid(_ value: Value) -> Bool {
        predicate(value)
    }

    public static func && (lhs: ValidationRule, rhs: ValidationRule) -> ValidationRule {
        ValidationRule { lhs.isValid($0) && rhs.isValid($0) }
    }

    public static func || (lhs: ValidationRule, rhs: ValidationRule) -> ValidationRule {
        ValidationRule { lhs.isValid($0) || rhs.isValid($0) }
    }

    public static prefix func ! (rule: ValidationRule) -> ValidationRule {
        ValidationRule { !rule.isValid($0) }
    }
}

// MARK: - String validators

/// Delegates to `Validations.validateEmail` for consistency with existing callers.
public struct EmailValidator: Validator {
    public init() { }
    public func isValid(_ value: String) -> Bool { Validations.validateEmail(value) }
}

/// Delegates to `Validations.validatePhoneNumber` (NSDataDetector-backed).
public struct PhoneValidator: Validator {
    public init() { }
    public func isValid(_ value: String) -> Bool { Validations.validatePhoneNumber(value) }
}

/// Delegates to `Validations.validateURL`.
public struct URLValidator: Validator {
    public init() { }
    public func isValid(_ value: String) -> Bool { Validations.validateURL(value) }
}

/// Validates a credit-card number using the Luhn checksum. Spaces and dashes
/// are allowed as separators; any other non-digit character fails.
public struct CreditCardValidator: Validator {
    public init() { }
    public func isValid(_ value: String) -> Bool {
        var digits: [Int] = []
        for character in value {
            if character == " " || character == "-" { continue }
            guard character.isASCII, let digit = character.wholeNumberValue else { return false }
            digits.append(digit)
        }
        guard (12...19).contains(digits.count) else { return false }
        var sum = 0
        for (index, digit) in digits.reversed().enumerated() {
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }
}

/// Validates a password against configurable strength requirements.
public struct PasswordValidator: Validator {

    public struct Requirements: Sendable, Equatable {
        public var minLength: Int
        public var requiresUppercase: Bool
        public var requiresLowercase: Bool
        public var requiresDigit: Bool
        public var requiresSpecialCharacter: Bool

        public init(
            minLength: Int = 8,
            requiresUppercase: Bool = true,
            requiresLowercase: Bool = true,
            requiresDigit: Bool = true,
            requiresSpecialCharacter: Bool = false
        ) {
            self.minLength = minLength
            self.requiresUppercase = requiresUppercase
            self.requiresLowercase = requiresLowercase
            self.requiresDigit = requiresDigit
            self.requiresSpecialCharacter = requiresSpecialCharacter
        }
    }

    private let requirements: Requirements

    public init(requirements: Requirements = .init()) {
        self.requirements = requirements
    }

    public func isValid(_ value: String) -> Bool {
        guard value.count >= requirements.minLength else { return false }
        if requirements.requiresUppercase, !value.contains(where: { $0.isUppercase }) { return false }
        if requirements.requiresLowercase, !value.contains(where: { $0.isLowercase }) { return false }
        if requirements.requiresDigit, !value.contains(where: { $0.isNumber }) { return false }
        if requirements.requiresSpecialCharacter,
           value.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil {
            return false
        }
        return true
    }
}

/// Validates a postal code for a given region. Falls back to a permissive
/// pattern for regions without a specific rule.
public struct PostalCodeValidator: Validator {

    private let regionCode: String

    public init(regionCode: String = Locale.current.region?.identifier ?? "US") {
        self.regionCode = regionCode.uppercased()
    }

    public func isValid(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        let pattern: String
        switch regionCode {
        case "US":
            pattern = "^\\d{5}(-\\d{4})?$"
        case "CA":
            pattern = "^[A-Za-z]\\d[A-Za-z] ?\\d[A-Za-z]\\d$"
        case "GB", "UK":
            pattern = "^[A-Za-z]{1,2}\\d[A-Za-z\\d]? ?\\d[A-Za-z]{2}$"
        case "DE", "FR", "IT", "ES":
            pattern = "^\\d{5}$"
        case "AU", "DK", "NO", "CH", "BE", "AT":
            pattern = "^\\d{4}$"
        case "NL":
            pattern = "^\\d{4} ?[A-Za-z]{2}$"
        case "JP":
            pattern = "^\\d{3}-?\\d{4}$"
        case "IN":
            pattern = "^\\d{6}$"
        default:
            pattern = "^[A-Za-z0-9 -]{2,10}$"
        }
        return trimmed.range(of: pattern, options: .regularExpression) != nil
    }
}
