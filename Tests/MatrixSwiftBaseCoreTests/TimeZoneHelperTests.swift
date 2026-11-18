import XCTest
@testable import MatrixSwiftBaseCore

final class TimeZoneHelperTests: XCTestCase {

    func testLookupByIdentifierOrAbbreviation() {
        XCTAssertEqual(TimeZoneHelper.timeZone("America/Toronto")?.identifier, "America/Toronto")
        XCTAssertNotNil(TimeZoneHelper.timeZone("UTC"))
        XCTAssertNil(TimeZoneHelper.timeZone("Not/AZone"))
        XCTAssertTrue(TimeZoneHelper.identifiers.contains("Europe/London"))
    }

    func testOffsetStringIsDSTAware() {
        let toronto = TimeZone(identifier: "America/Toronto")!
        let summer = DateHelper.date(fromISO8601: "2026-07-09T15:00:00Z")!
        let winter = DateHelper.date(fromISO8601: "2026-01-09T15:00:00Z")!
        XCTAssertEqual(TimeZoneHelper.offsetString(of: toronto, at: summer), "-04:00")
        XCTAssertEqual(TimeZoneHelper.offsetString(of: toronto, at: winter), "-05:00")
        XCTAssertEqual(TimeZoneHelper.offsetString(of: TimeZone(identifier: "Asia/Kolkata")!, at: summer), "+05:30")
    }

    func testConvertWallClockKeepsLocalTime() {
        let toronto = TimeZone(identifier: "America/Toronto")!
        let london = TimeZone(identifier: "Europe/London")!
        // 09:00 in Toronto (13:00Z) becomes 09:00 in London (08:00Z, BST).
        let nineToronto = DateHelper.date(fromISO8601: "2026-07-09T13:00:00Z")!
        let converted = TimeZoneHelper.convertWallClock(nineToronto, from: toronto, to: london)!
        XCTAssertEqual(DateHelper.iso8601String(from: converted), "2026-07-09T08:00:00Z")
    }
}
