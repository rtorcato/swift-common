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
}
