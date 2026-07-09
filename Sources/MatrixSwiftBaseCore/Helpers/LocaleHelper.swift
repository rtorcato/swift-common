//
//  LocaleHelper.swift
//  MatrixSwiftBase
//
//  Locale inspection and a runtime locale override. Uses Foundation's Locale
//  APIs directly — no reimplementation of what the platform already does.
//

import Foundation

public final class LocaleHelper {

    public init() { }

    /// The locale the app should use. Defaults to the system locale; set this
    /// to switch locales at runtime.
    // ponytail: plain mutable static; a Sendable/thread-safe wrapper is issue #14's job.
    public static var current: Locale = .current

    /// All locale identifiers the system knows about.
    public static var availableIdentifiers: [String] { Locale.availableIdentifiers }

    /// ISO currency code for a locale, e.g. `"USD"`.
    public static func currencyCode(for locale: Locale = current) -> String? {
        locale.currency?.identifier
    }

    /// Language code for a locale, e.g. `"en"`.
    public static func languageCode(for locale: Locale = current) -> String? {
        locale.language.languageCode?.identifier
    }

    /// Region code for a locale, e.g. `"US"`.
    public static func regionCode(for locale: Locale = current) -> String? {
        locale.region?.identifier
    }

    /// Localized display name of a locale identifier, rendered in `displayLocale`.
    public static func displayName(for identifier: String, in displayLocale: Locale = current) -> String? {
        displayLocale.localizedString(forIdentifier: identifier)
    }
}
