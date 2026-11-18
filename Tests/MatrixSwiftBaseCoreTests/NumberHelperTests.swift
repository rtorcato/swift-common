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

    func testIntFromStringOutOfRangeReturnsNil() {
        XCTAssertNil(NumberHelper.int(from: "1e30", locale: en))
    }

    func testDecimalFromStringKeepsPrecision() {
        XCTAssertEqual(NumberHelper.decimal(from: "0.1", locale: en), Decimal(string: "0.1"))
        XCTAssertNil(NumberHelper.decimal(from: "nope", locale: en))
    }

    func testFormatDecimalValue() {
        XCTAssertEqual(NumberHelper.decimal(Decimal(string: "1234.5")!, fractionDigits: 2, locale: en), "1,234.50")
    }

    func testCompactNotation() {
        XCTAssertEqual(NumberHelper.compact(1_200, locale: en), "1.2K")
        XCTAssertEqual(NumberHelper.compact(3_400_000, locale: en), "3.4M")
    }

    func testIsInteger() {
        XCTAssertTrue(NumberHelper.isInteger("42"))
        XCTAssertTrue(NumberHelper.isInteger("-7"))
        XCTAssertFalse(NumberHelper.isInteger("-7", allowSigned: false))
        XCTAssertFalse(NumberHelper.isInteger("4.2"))
        XCTAssertFalse(NumberHelper.isInteger(""))
        XCTAssertFalse(NumberHelper.isInteger("-"))
    }

    func testIsDecimal() {
        XCTAssertTrue(NumberHelper.isDecimal("3.14", locale: en))
        XCTAssertTrue(NumberHelper.isDecimal("-0.5", locale: en))
        XCTAssertTrue(NumberHelper.isDecimal(".5", locale: en))
        XCTAssertTrue(NumberHelper.isDecimal("10", locale: en))
        XCTAssertFalse(NumberHelper.isDecimal("1.", locale: en))
        XCTAssertFalse(NumberHelper.isDecimal("1.2.3", locale: en))
        XCTAssertFalse(NumberHelper.isDecimal("-", locale: en))
        XCTAssertFalse(NumberHelper.isDecimal("+1.5", allowSigned: false, locale: en))
        XCTAssertTrue(NumberHelper.isDecimal("3,14", locale: Locale(identifier: "fr_FR")))
    }

    func testClampToRange() {
        XCTAssertEqual(NumberHelper.clamp(150, to: 0...100), 100)
        XCTAssertEqual(NumberHelper.clamp(-1.5, to: 0.0...1.0), 0.0)
    }
}
