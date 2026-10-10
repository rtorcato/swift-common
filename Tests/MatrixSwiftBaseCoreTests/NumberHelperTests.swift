import XCTest
@testable import MatrixSwiftBaseCore

final class NumberHelperTests: XCTestCase {

    private let en = Locale(identifier: "en_US")

    func testDoubleFromString() {
        XCTAssertEqual(NumberHelper.double(from: "1,234.5", locale: en), 1234.5)
        XCTAssertNil(NumberHelper.double(from: "abc", locale: en))
    }

    func testIntFromStringTruncates() {
        XCTAssertEqual(NumberHelper.int(from: "42.9", locale: en), 42)
    }

    func testDecimalFixedFractionDigits() {
        XCTAssertEqual(NumberHelper.decimal(3.14159, fractionDigits: 2, locale: en), "3.14")
    }

    func testPercentFromRatio() {
        XCTAssertEqual(NumberHelper.percent(0.42, locale: en), "42%")
        XCTAssertEqual(NumberHelper.percent(0.4256, fractionDigits: 1, locale: en), "42.6%")
    }

    func testScientificNotation() {
        XCTAssertEqual(NumberHelper.scientific(1234, locale: en), "1.234E3")
    }
}
