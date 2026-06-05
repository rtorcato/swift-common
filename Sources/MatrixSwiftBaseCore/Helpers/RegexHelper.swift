//
//  RegexHelper.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-05.
//

import Foundation

public final class RegexHelper {

    public init() { }

    /// Whether the input matches the given pattern at least once.
    public static func matches(_ pattern: String, in input: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let range = NSRange(input.startIndex..., in: input)
        return regex.firstMatch(in: input, range: range) != nil
    }

    /// All non-overlapping matches of the pattern as substrings.
    public static func allMatches(_ pattern: String, in input: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let range = NSRange(input.startIndex..., in: input)
        return regex.matches(in: input, range: range).compactMap { match in
            Range(match.range, in: input).map { String(input[$0]) }
        }
    }

    /// Replace every match of the pattern with the given template.
    /// Template supports `$1`, `$2`, … back-references to capture groups.
    public static func replace(_ pattern: String, with template: String, in input: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return input }
        let range = NSRange(input.startIndex..., in: input)
        return regex.stringByReplacingMatches(in: input, range: range, withTemplate: template)
    }

    /// First match plus its capture groups. Element 0 is the full match;
    /// remaining elements are each capture group, in order.
    /// Returns nil if the pattern doesn't compile or doesn't match.
    public static func captureGroups(_ pattern: String, in input: String) -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let nsRange = NSRange(input.startIndex..., in: input)
        guard let match = regex.firstMatch(in: input, range: nsRange) else { return nil }
        return (0..<match.numberOfRanges).compactMap { idx in
            guard let r = Range(match.range(at: idx), in: input) else { return nil }
            return String(input[r])
        }
    }
}
