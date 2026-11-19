import XCTest
@testable import MatrixSwiftBaseCore

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

    func testElementsSampleCountAndDistinctness() {
        let source = Array(1...10)
        let sample = RandomHelper.elements(from: source, count: 4)
        XCTAssertEqual(sample.count, 4)
        XCTAssertEqual(Set(sample).count, 4) // no duplicates
        XCTAssertTrue(sample.allSatisfy { source.contains($0) })
    }

    func testElementsClampsToCollectionSize() {
        let sample = RandomHelper.elements(from: [1, 2, 3], count: 10)
        XCTAssertEqual(Set(sample), [1, 2, 3])
        XCTAssertEqual(RandomHelper.elements(from: [1, 2, 3], count: 0), [])
    }

    func testSeededGeneratorIsDeterministic() {
        var genA = SeededGenerator(seed: 42)
        var genB = SeededGenerator(seed: 42)
        let source = Array(1...20)
        XCTAssertEqual(
            RandomHelper.elements(from: source, count: 5, using: &genA),
            RandomHelper.elements(from: source, count: 5, using: &genB)
        )
    }

    func testSamplesWithReplacementReturnsExactCount() {
        let sample = RandomHelper.samples(from: [1, 2], count: 10)
        XCTAssertEqual(sample.count, 10)
        XCTAssertTrue(sample.allSatisfy { [1, 2].contains($0) })
        XCTAssertEqual(RandomHelper.samples(from: [Int](), count: 3), [])
    }

    func testCollectionRandomElements() {
        let source = Set(1...10)
        let distinct = source.randomElements(count: 4)
        XCTAssertEqual(Set(distinct).count, 4)
        XCTAssertEqual(source.randomElements(count: 25, withReplacement: true).count, 25)
    }

    func testSeededSamplesAreDeterministic() {
        var genA = SeededGenerator(seed: 7)
        var genB = SeededGenerator(seed: 7)
        XCTAssertEqual(
            Array(1...20).randomElements(count: 8, withReplacement: true, using: &genA),
            Array(1...20).randomElements(count: 8, withReplacement: true, using: &genB)
        )
    }
}
