import XCTest
@testable import MatrixSwiftBaseCore

final class PluralizationHelperTests: XCTestCase {
    func testPluralizePicksFormByCount() {
        XCTAssertEqual(PluralizationHelper.pluralize(1, singular: "file", plural: "files"), "file")
        XCTAssertEqual(PluralizationHelper.pluralize(0, singular: "file", plural: "files"), "files")
        XCTAssertEqual(PluralizationHelper.pluralize(5, singular: "file", plural: "files"), "files")
    }

    func testFormatIncludesCount() {
        XCTAssertEqual(PluralizationHelper.format(1, singular: "file", plural: "files"), "1 file")
        XCTAssertEqual(PluralizationHelper.format(5, singular: "file", plural: "files"), "5 files")
    }

    func testFormatZeroOverride() {
        XCTAssertEqual(PluralizationHelper.format(0, singular: "file", plural: "files", zero: "no files"), "no files")
        XCTAssertEqual(PluralizationHelper.format(0, singular: "file", plural: "files"), "0 files")
    }
}
