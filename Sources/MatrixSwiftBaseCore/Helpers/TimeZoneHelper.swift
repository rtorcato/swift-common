//
//  TimeZoneHelper.swift
//  MatrixSwiftBase
//
//  Time-zone lookup and wall-clock conversion. Formatting a date in a
//  given zone lives in `DateHelper.string(from:format:timeZone:locale:)`.
//

import Foundation

public final class TimeZoneHelper: Sendable {

    public init() { }

    /// A time zone from an IANA identifier (`"America/Toronto"`) or an
    /// abbreviation (`"EST"`, `"UTC"`). Returns nil if neither resolves.
    public static func timeZone(_ identifierOrAbbreviation: String) -> TimeZone? {
        TimeZone(identifier: identifierOrAbbreviation) ?? TimeZone(abbreviation: identifierOrAbbreviation)
    }

    /// All IANA identifiers known to the system.
    public static var identifiers: [String] {
        TimeZone.knownTimeZoneIdentifiers
    }

    /// Offset from GMT in seconds for `timeZone` at `date` (DST-aware).
    public static func offset(of timeZone: TimeZone, at date: Date = Date()) -> Int {
        timeZone.secondsFromGMT(for: date)
    }

    /// Offset as an ISO-8601 string, e.g. `"-05:00"` or `"+00:00"`.
    public static func offsetString(of timeZone: TimeZone, at date: Date = Date()) -> String {
        let seconds = offset(of: timeZone, at: date)
        let sign = seconds < 0 ? "-" : "+"
        let minutes = abs(seconds) / 60
        return String(format: "%@%02d:%02d", sign, minutes / 60, minutes % 60)
    }

    /// Reinterpret `date`'s wall-clock time in `source` as the same wall-clock
    /// time in `destination`. For example 09:00 Toronto becomes 09:00 London.
    /// A `Date` is an absolute instant; use this only when you need to move a
    /// local time between zones, not to display an instant elsewhere.
    public static func convertWallClock(_ date: Date, from source: TimeZone, to destination: TimeZone) -> Date? {
        var sourceCalendar = Calendar(identifier: .gregorian)
        sourceCalendar.timeZone = source
        var destinationCalendar = Calendar(identifier: .gregorian)
        destinationCalendar.timeZone = destination
        let parts = sourceCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        return destinationCalendar.date(from: parts)
    }
}
