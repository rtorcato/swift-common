import XCTest
@testable import MatrixSwiftBaseCore

final class EnvHelperTests: XCTestCase {

    func testStringReturnsNilForUnset() {
        XCTAssertNil(EnvHelper.string("MATRIX_SWIFT_BASE_TEST_UNSET_XYZ"))
    }

    func testStringWithDefaultFallsBack() {
        let value = EnvHelper.string("MATRIX_SWIFT_BASE_TEST_UNSET_XYZ", default: "fallback")
        XCTAssertEqual(value, "fallback")
    }

    func testIntReturnsNilForUnset() {
        XCTAssertNil(EnvHelper.int("MATRIX_SWIFT_BASE_TEST_UNSET_XYZ"))
    }

    func testIntWithDefaultFallsBack() {
        XCTAssertEqual(EnvHelper.int("MATRIX_SWIFT_BASE_TEST_UNSET_XYZ", default: 42), 42)
    }

    func testBoolFallsBackToDefault() {
        XCTAssertTrue(EnvHelper.bool("MATRIX_SWIFT_BASE_TEST_UNSET_XYZ", default: true))
        XCTAssertFalse(EnvHelper.bool("MATRIX_SWIFT_BASE_TEST_UNSET_XYZ"))
    }

    func testReadsKnownProcessVariable() {
        // PATH is set in essentially every shell environment; PATH-less environments
        // are out of scope for this test.
        let path = EnvHelper.string("PATH")
        XCTAssertNotNil(path)
        XCTAssertFalse(path?.isEmpty ?? true)
    }

    func testAllExposesEnvironment() {
        XCTAssertEqual(EnvHelper.all, ProcessInfo.processInfo.environment)
    }
}
