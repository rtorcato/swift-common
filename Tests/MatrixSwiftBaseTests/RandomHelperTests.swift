import XCTest
@testable import MatrixSwiftBase

final class RandomHelperTests: XCTestCase {

    func testIntStaysInRange() {
        for _ in 0..<100 {
            let value = RandomHelper.int(in: 1...10)
            XCTAssertGreaterThanOrEqual(value, 1)
            XCTAssertLessThanOrEqual(value, 10)
        }
    }

    func testDoubleStaysInRange() {
        for _ in 0..<100 {
            let value = RandomHelper.double(in: 0.0...1.0)
            XCTAssertGreaterThanOrEqual(value, 0.0)
            XCTAssertLessThanOrEqual(value, 1.0)
        }
    }

    func testElementFromEmptyArrayReturnsNil() {
        let result: Int? = RandomHelper.element(from: [])
        XCTAssertNil(result)
    }

    func testElementFromSingleArray() {
        let result = RandomHelper.element(from: [42])
        XCTAssertEqual(result, 42)
    }

    func testStringLength() {
        XCTAssertEqual(RandomHelper.string(length: 16).count, 16)
        XCTAssertEqual(RandomHelper.string(length: 0).count, 0)
        XCTAssertEqual(RandomHelper.string(length: -5).count, 0)
    }

    func testStringIsAlphanumeric() {
        let allowed = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
        let generated = RandomHelper.string(length: 100)
        XCTAssertTrue(generated.allSatisfy { allowed.contains($0) })
    }
}
