//
//  PluralizationHelper.swift
//  MatrixSwiftBase
//
//  Inline pluralization for the common English "1 file / 5 files" case.
//
//  For full CLDR plural categories in non-English locales (one/few/many/other),
//  use a `.stringsdict` file — that is the platform-supported path and this
//  helper deliberately does not reimplement the CLDR ruleset.
//

import Foundation

public enum PluralizationHelper {

    /// Pick the singular form when `count == 1`, otherwise the plural form.
    public static func pluralize(_ count: Int, singular: String, plural: String) -> String {
        count == 1 ? singular : plural
    }

    /// Format a count with its noun, e.g. `format(5, singular: "file", plural: "files")` → `"5 files"`.
    /// Pass `zero` to special-case an empty count (`"no files"`).
    public static func format(_ count: Int, singular: String, plural: String, zero: String? = nil) -> String {
        if count == 0, let zero { return zero }
        return "\(count) \(pluralize(count, singular: singular, plural: plural))"
    }
}
