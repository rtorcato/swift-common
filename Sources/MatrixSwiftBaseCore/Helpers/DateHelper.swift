//
//  DateHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-25.
//

import Foundation

public final class DateHelper: Sendable {

    static let instance = DateHelper()
    private init() { }
    
    // MARK: Checking if current Date is Today
    public static func isToday(date: Date) -> Bool {
        let currentDay: Date = Date()
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }

    // MARK: Checking currentHour
    public static func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        return hour == currentHour
    }
    
    // MARK: Extracting Date
    public static func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    // MARK: Get current time interval
    public static func getCurrentTimeInterval() -> TimeInterval {
        let startTime = NSDate()
        let interval = startTime.timeIntervalSince1970
        return interval
    }

    public static func getEndDate(calComponent: Calendar.Component = .second, value: Int) -> Date? {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: calComponent, value: value, to: Date())
        return endDate
    }

    // MARK: ISO-8601

    // Formatters are not Sendable, so each call builds its own rather than
    // sharing a static instance across concurrency domains.
    private static var iso8601Formatter: ISO8601DateFormatter { ISO8601DateFormatter() }

    /// ISO-8601 string, e.g. `"2026-07-09T15:00:00Z"`.
    public static func iso8601String(from date: Date) -> String {
        iso8601Formatter.string(from: date)
    }

    /// Parse an ISO-8601 string. Returns nil if it doesn't parse.
    public static func date(fromISO8601 string: String) -> Date? {
        iso8601Formatter.date(from: string)
    }

    // MARK: Relative time

    private static var relativeFormatter: RelativeDateTimeFormatter { RelativeDateTimeFormatter() }

    /// Human relative string, e.g. `"3 hours ago"`, `"in 2 days"`.
    public static func relativeString(for date: Date, relativeTo reference: Date = Date()) -> String {
        relativeFormatter.localizedString(for: date, relativeTo: reference)
    }

    // MARK: Timezone-aware formatting

    /// Format a date with an explicit format, time zone, and locale.
    public static func string(from date: Date, format: String, timeZone: TimeZone = .current, locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.string(from: date)
    }

    // MARK: RFC 822

    /// Parse an RFC 822 date as used in RSS / podcast feeds,
    /// e.g. `"Wed, 04 Nov 2015 21:00:14 +0000"`.
    public static func dateWithPodcastDateString(_ dateString: String) -> Date? {
        posixFormatter("EEE, dd MMM yyyy HH:mm:ss Z").date(from: dateString)
    }

    /// Display string like `"21:00 November 04, 2015"` (en_US, current time zone).
    public static func displayString(for date: Date) -> String {
        posixFormatter("HH:mm MMMM dd, yyyy").string(from: date)
    }

    private static func posixFormatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter
    }

    // MARK: Time zones

    /// The same instant formatted as ISO-8601 in `timeZone`,
    /// e.g. `"2026-07-09T11:00:00-04:00"`.
    public static func iso8601String(from date: Date, in timeZone: TimeZone) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = timeZone
        return formatter.string(from: date)
    }

    // MARK: Business days

    /// True if `date` falls on a weekend in `calendar` (locale-aware).
    public static func isWeekend(_ date: Date, calendar: Calendar = .current) -> Bool {
        calendar.isDateInWeekend(date)
    }

    /// Add (or, when negative, subtract) `days` business days, skipping weekends.
    /// Starting on a weekend, the first step lands on the next (or previous) weekday.
    public static func addingBusinessDays(_ days: Int, to date: Date, calendar: Calendar = .current) -> Date? {
        let step = days < 0 ? -1 : 1
        var remaining = abs(days)
        var current = date
        while remaining > 0 {
            guard let next = calendar.date(byAdding: .day, value: step, to: current) else { return nil }
            current = next
            if !calendar.isDateInWeekend(current) { remaining -= 1 }
        }
        return current
    }

    /// Number of weekdays after `start`'s day up to and including `end`'s day.
    /// Negative when `end` is before `start`.
    public static func businessDays(from start: Date, to end: Date, calendar: Calendar = .current) -> Int {
        let from = calendar.startOfDay(for: min(start, end))
        let to = calendar.startOfDay(for: max(start, end))
        var count = 0
        var current = from
        while current < to, let next = calendar.date(byAdding: .day, value: 1, to: current) {
            current = next
            if !calendar.isDateInWeekend(current) { count += 1 }
        }
        return start <= end ? count : -count
    }
}
