import XCTest
@testable import MatrixSwiftBaseCore

final class DictionaryExtTests: XCTestCase {

    func testMapKeys() {
        let input = ["a": 1, "b": 2, "c": 3]
        let result = input.mapKeys { $0.uppercased() }
        XCTAssertEqual(result, ["A": 1, "B": 2, "C": 3])
    }

    func testMapKeysCollidingProducesOneEntry() {
        let input = ["foo": 1, "FOO": 2]
        let result = input.mapKeys { $0.lowercased() }
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(Set(result.keys), ["foo"])
    }

    func testFilteringKeys() {
        let input = ["keep_1": 1, "keep_2": 2, "drop_3": 3]
        let result = input.filteringKeys { $0.hasPrefix("keep_") }
        XCTAssertEqual(result, ["keep_1": 1, "keep_2": 2])
    }

    func testKeysToCamelCase() {
        let input = ["first_name": "Jane", "last_name": "Doe", "id": 1] as [String: Any]
        let result = input.keysToCamelCase()
        XCTAssertEqual(Set(result.keys), ["firstName", "lastName", "id"])
    }

    func testKeysToSnakeCase() {
        let input = ["firstName": "Jane", "lastName": "Doe", "id": 1] as [String: Any]
        let result = input.keysToSnakeCase()
        XCTAssertEqual(Set(result.keys), ["first_name", "last_name", "id"])
    }

    func testCamelToSnakeRoundTrip() {
        let original = ["userId": 1, "createdAt": "now"] as [String: Any]
        let roundTripped = original.keysToSnakeCase().keysToCamelCase()
        XCTAssertEqual(Set(roundTripped.keys), Set(original.keys))
    }
}
