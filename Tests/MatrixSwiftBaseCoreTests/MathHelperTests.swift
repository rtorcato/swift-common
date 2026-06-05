import XCTest
@testable import MatrixSwiftBaseCore

final class MathHelperTests: XCTestCase {

    func testClampWithinRange() {
        XCTAssertEqual(MathHelper.clamp(5, min: 0, max: 10), 5)
    }

    func testClampBelowMin() {
        XCTAssertEqual(MathHelper.clamp(-3, min: 0, max: 10), 0)
    }

    func testClampAboveMax() {
        XCTAssertEqual(MathHelper.clamp(99, min: 0, max: 10), 10)
    }

    func testLerpHalfway() {
        XCTAssertEqual(MathHelper.lerp(from: 0.0, to: 10.0, t: 0.5), 5.0, accuracy: 0.0001)
    }

    func testLerpEndpoints() {
        XCTAssertEqual(MathHelper.lerp(from: 2.0, to: 8.0, t: 0.0), 2.0, accuracy: 0.0001)
        XCTAssertEqual(MathHelper.lerp(from: 2.0, to: 8.0, t: 1.0), 8.0, accuracy: 0.0001)
    }

    func testMapRange() {
        let result = MathHelper.mapRange(50.0, fromMin: 0.0, fromMax: 100.0, toMin: 0.0, toMax: 1.0)
        XCTAssertEqual(result, 0.5, accuracy: 0.0001)
    }

    func testMapRangeDegenerateFromRangeReturnsToMin() {
        let result = MathHelper.mapRange(5.0, fromMin: 10.0, fromMax: 10.0, toMin: 1.0, toMax: 2.0)
        XCTAssertEqual(result, 1.0, accuracy: 0.0001)
    }

    func testRoundedTo() {
        XCTAssertEqual(MathHelper.roundedTo(3.14159, places: 2), 3.14, accuracy: 0.0001)
        XCTAssertEqual(MathHelper.roundedTo(2.5, places: 0), 3.0, accuracy: 0.0001)
    }

    func testDegreesRadiansRoundTrip() {
        let original = 90.0
        let radians = MathHelper.degreesToRadians(original)
        XCTAssertEqual(radians, .pi / 2.0, accuracy: 0.0001)
        XCTAssertEqual(MathHelper.radiansToDegrees(radians), original, accuracy: 0.0001)
    }
}
