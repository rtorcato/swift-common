import XCTest
@testable import MatrixSwiftBaseCore

final class RegexHelperTests: XCTestCase {

    func testMatchesTrue() {
        XCTAssertTrue(RegexHelper.matches("[0-9]+", in: "abc 123"))
    }

    func testMatchesFalse() {
        XCTAssertFalse(RegexHelper.matches("[0-9]+", in: "no digits"))
    }

    func testMatchesInvalidPatternReturnsFalse() {
        XCTAssertFalse(RegexHelper.matches("[unclosed", in: "anything"))
    }

    func testAllMatchesFindsEverything() {
        XCTAssertEqual(RegexHelper.allMatches("[0-9]+", in: "1 fish 2 fish 33 red"), ["1", "2", "33"])
    }

    func testAllMatchesEmptyOnNoMatch() {
        XCTAssertEqual(RegexHelper.allMatches("z+", in: "abc"), [])
    }

    func testReplaceWithBackReference() {
        let result = RegexHelper.replace("(\\d{3})-(\\d{4})", with: "$1.$2", in: "Call 555-1234")
        XCTAssertEqual(result, "Call 555.1234")
    }

    func testReplaceNoMatchReturnsOriginal() {
        XCTAssertEqual(RegexHelper.replace("xyz", with: "abc", in: "hello"), "hello")
    }

    func testCaptureGroups() {
        let groups = RegexHelper.captureGroups("(\\w+)@(\\w+)", in: "user@domain")
        XCTAssertEqual(groups, ["user@domain", "user", "domain"])
    }

    func testCaptureGroupsNoMatchReturnsNil() {
        XCTAssertNil(RegexHelper.captureGroups("(\\d+)", in: "no digits"))
    }
}
