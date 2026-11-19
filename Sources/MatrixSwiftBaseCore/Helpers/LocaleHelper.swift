//
//  LocaleHelper.swift
//  MatrixSwiftBase
//
//  Locale inspection and a runtime locale override. Uses Foundation's Locale
//  APIs directly — no reimplementation of what the platform already does.
//

import Foundation

public final class LocaleHelper: Sendable {

    public init() { }

    private static let storage = LockedLocale()

    /// The locale the app should use. Defaults to the system locale; set this
    /// to switch locales at runtime. Reads and writes are thread-safe.
    public static var current: Locale {
        get { storage.value }
        set { storage.value = newValue }
    }

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

/// Lock-guarded storage so the runtime override is safe under strict concurrency.
private final class LockedLocale: @unchecked Sendable {
    private let lock = NSLock()
    private var locale: Locale = .current

    var value: Locale {
        get { lock.lock(); defer { lock.unlock() }; return locale }
        set { lock.lock(); defer { lock.unlock() }; locale = newValue }
    }
}
