import XCTest
@testable import MatrixSwiftBaseCore

final class DateHelperTests: XCTestCase {

    func testISO8601RoundTrip() {
        let iso = "2026-07-09T15:00:00Z"
        let date = DateHelper.date(fromISO8601: iso)
        XCTAssertNotNil(date)
        XCTAssertEqual(DateHelper.iso8601String(from: date!), iso)
    }

    func testISO8601InvalidReturnsNil() {
        XCTAssertNil(DateHelper.date(fromISO8601: "not a date"))
    }

    func testRelativeStringInPast() {
        let twoHoursAgo = Date().addingTimeInterval(-7200)
        let text = DateHelper.relativeString(for: twoHoursAgo)
        XCTAssertFalse(text.isEmpty)
    }

    func testTimezoneAwareFormatting() {
        // 2026-07-09T15:00:00Z formatted in UTC.
        let date = DateHelper.date(fromISO8601: "2026-07-09T15:00:00Z")!
        let formatted = DateHelper.string(
            from: date,
            format: "yyyy-MM-dd HH:mm",
            timeZone: TimeZone(identifier: "UTC")!,
            locale: Locale(identifier: "en_US_POSIX")
        )
        XCTAssertEqual(formatted, "2026-07-09 15:00")
    }

    func testIsToday() {
        XCTAssertTrue(DateHelper.isToday(date: Date()))
        XCTAssertFalse(DateHelper.isToday(date: Date().addingTimeInterval(-86400 * 2)))
    }

    private var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    func testPodcastDateParsing() {
        let date = DateHelper.dateWithPodcastDateString("Wed, 04 Nov 2015 21:00:14 +0000")
        XCTAssertEqual(date.map(DateHelper.iso8601String(from:)), "2015-11-04T21:00:14Z")
    }

    func testISO8601InTimeZone() {
        let date = DateHelper.date(fromISO8601: "2026-07-09T15:00:00Z")!
        XCTAssertEqual(
            DateHelper.iso8601String(from: date, in: TimeZone(identifier: "America/Toronto")!),
            "2026-07-09T11:00:00-04:00"
        )
    }

    func testAddingBusinessDaysSkipsWeekend() {
        // 2026-07-10 is a Friday.
        let friday = DateHelper.date(fromISO8601: "2026-07-10T12:00:00Z")!
        let monday = DateHelper.addingBusinessDays(1, to: friday, calendar: utcCalendar)!
        XCTAssertEqual(DateHelper.iso8601String(from: monday), "2026-07-13T12:00:00Z")
        let back = DateHelper.addingBusinessDays(-1, to: monday, calendar: utcCalendar)!
        XCTAssertEqual(DateHelper.iso8601String(from: back), "2026-07-10T12:00:00Z")
        XCTAssertEqual(DateHelper.addingBusinessDays(0, to: friday, calendar: utcCalendar), friday)
    }

    func testBusinessDaysBetween() {
        let friday = DateHelper.date(fromISO8601: "2026-07-10T12:00:00Z")!
        let nextFriday = DateHelper.date(fromISO8601: "2026-07-17T12:00:00Z")!
        XCTAssertEqual(DateHelper.businessDays(from: friday, to: nextFriday, calendar: utcCalendar), 5)
        XCTAssertEqual(DateHelper.businessDays(from: nextFriday, to: friday, calendar: utcCalendar), -5)
        XCTAssertTrue(DateHelper.isWeekend(DateHelper.date(fromISO8601: "2026-07-11T12:00:00Z")!, calendar: utcCalendar))
    }
}
