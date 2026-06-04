import XCTest
@testable import MatrixSwiftBase

final class SetExtTests: XCTestCase {

    func testContainsAllTrue() {
        let set: Set = [1, 2, 3, 4]
        XCTAssertTrue(set.containsAll([2, 3]))
    }

    func testContainsAllFalse() {
        let set: Set = [1, 2, 3]
        XCTAssertFalse(set.containsAll([2, 5]))
    }

    func testContainsAllEmptySequenceIsTrue() {
        let set: Set<Int> = [1, 2, 3]
        XCTAssertTrue(set.containsAll([Int]()))
    }

    func testContainsAnyTrue() {
        let set: Set = [1, 2, 3]
        XCTAssertTrue(set.containsAny([5, 6, 2]))
    }

    func testContainsAnyFalse() {
        let set: Set = [1, 2, 3]
        XCTAssertFalse(set.containsAny([5, 6, 7]))
    }

    func testContainsAnyEmptySequenceIsFalse() {
        let set: Set<Int> = [1, 2, 3]
        XCTAssertFalse(set.containsAny([Int]()))
    }

    func testToggleAddsAbsentElement() {
        var set: Set = [1, 2]
        set.toggle(3)
        XCTAssertEqual(set, [1, 2, 3])
    }

    func testToggleRemovesPresentElement() {
        var set: Set = [1, 2, 3]
        set.toggle(2)
        XCTAssertEqual(set, [1, 3])
    }
}
