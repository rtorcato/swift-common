import XCTest
@testable import MatrixSwiftBaseCore

final class GeometryHelperTests: XCTestCase {

    func testDistanceAxisAligned() {
        XCTAssertEqual(GeometryHelper.distance(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 3, y: 0)), 3, accuracy: 0.0001)
    }

    func testDistance345Triangle() {
        XCTAssertEqual(GeometryHelper.distance(from: .zero, to: CGPoint(x: 3, y: 4)), 5, accuracy: 0.0001)
    }

    func testMidpoint() {
        let result = GeometryHelper.midpoint(CGPoint(x: 0, y: 0), CGPoint(x: 10, y: 20))
        XCTAssertEqual(result, CGPoint(x: 5, y: 10))
    }

    func testCenterOfRect() {
        let rect = CGRect(x: 10, y: 20, width: 40, height: 60)
        XCTAssertEqual(GeometryHelper.center(of: rect), CGPoint(x: 30, y: 50))
    }

    func testInsetShrinks() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        XCTAssertEqual(GeometryHelper.inset(rect, by: 10), CGRect(x: 10, y: 10, width: 80, height: 80))
    }

    func testInsetNegativeExpands() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        XCTAssertEqual(GeometryHelper.inset(rect, by: -5), CGRect(x: -5, y: -5, width: 110, height: 110))
    }

    func testContainsPoint() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        XCTAssertTrue(GeometryHelper.contains(rect, point: CGPoint(x: 50, y: 50)))
        XCTAssertFalse(GeometryHelper.contains(rect, point: CGPoint(x: 200, y: 200)))
    }

    func testAspectRatio() {
        XCTAssertEqual(GeometryHelper.aspectRatio(CGSize(width: 16, height: 9)), 16.0 / 9.0, accuracy: 0.0001)
    }

    func testAspectRatioZeroHeight() {
        XCTAssertEqual(GeometryHelper.aspectRatio(CGSize(width: 10, height: 0)), 0)
    }
}
