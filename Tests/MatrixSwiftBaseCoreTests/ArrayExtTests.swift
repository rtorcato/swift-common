import XCTest
@testable import MatrixSwiftBaseCore

final class ArrayExtTests: XCTestCase {

    func testSafeSubscriptInBounds() {
        let array = [10, 20, 30]
        XCTAssertEqual(array[safe: 1], 20)
    }

    func testSafeSubscriptOutOfBoundsReturnsNil() {
        let array = [10, 20, 30]
        XCTAssertNil(array[safe: 5])
        XCTAssertNil(array[safe: -1])
    }

    func testSafeSubscriptEmptyArray() {
        let array: [Int] = []
        XCTAssertNil(array[safe: 0])
    }

    func testChunkedEvenSplit() {
        let chunked = [1, 2, 3, 4].chunked(into: 2)
        XCTAssertEqual(chunked, [[1, 2], [3, 4]])
    }

    func testChunkedUnevenSplit() {
        let chunked = [1, 2, 3, 4, 5].chunked(into: 2)
        XCTAssertEqual(chunked, [[1, 2], [3, 4], [5]])
    }

    func testChunkedZeroSizeReturnsEmpty() {
        let chunked = [1, 2, 3].chunked(into: 0)
        XCTAssertTrue(chunked.isEmpty)
    }

    func testUniquePreservesOrder() {
        let result = [3, 1, 2, 1, 3, 4].unique()
        XCTAssertEqual(result, [3, 1, 2, 4])
    }

    func testUniqueOnEmptyArray() {
        let result: [Int] = [].unique()
        XCTAssertEqual(result, [])
    }

    func testGroupedByParity() {
        let result = [1, 2, 3, 4, 5].grouped(by: { $0 % 2 == 0 ? "even" : "odd" })
        XCTAssertEqual(result["even"], [2, 4])
        XCTAssertEqual(result["odd"], [1, 3, 5])
    }
}
