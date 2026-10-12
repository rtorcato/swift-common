import XCTest
@testable import MatrixSwiftBaseCore

final class CodableHelperTests: XCTestCase {

    func testValueAtKeyPath() {
        let data = Data(#"{"user":{"name":"Ada","age":36}}"#.utf8)
        XCTAssertEqual(CodableHelper.value(String.self, at: "user.name", in: data), "Ada")
        XCTAssertEqual(CodableHelper.value(Int.self, at: "user.age", in: data), 36)
        XCTAssertNil(CodableHelper.value(String.self, at: "user.missing", in: data))
    }

    func testEncodeOmittingKeys() {
        struct Person: Encodable { let name: String; let secret: String }
        let data = CodableHelper.encode(Person(name: "Ada", secret: "x"), omitting: ["secret"])
        XCTAssertNotNil(data)
        let object = try? JSONSerialization.jsonObject(with: data!) as? [String: Any]
        XCTAssertEqual((object ?? [:])["name"] as? String, "Ada")
        XCTAssertNil((object ?? [:])["secret"])
    }

    func testDeepMerge() {
        let base: [String: Any] = ["a": 1, "nested": ["x": 1, "y": 2]]
        let override: [String: Any] = ["b": 2, "nested": ["y": 20, "z": 3]]
        let merged = CodableHelper.deepMerge(base, override)
        XCTAssertEqual(merged["a"] as? Int, 1)
        XCTAssertEqual(merged["b"] as? Int, 2)
        let nested = merged["nested"] as? [String: Any]
        XCTAssertEqual(nested?["x"] as? Int, 1)
        XCTAssertEqual(nested?["y"] as? Int, 20) // override wins
        XCTAssertEqual(nested?["z"] as? Int, 3)
    }

    func testKeyCaseConversion() {
        XCTAssertEqual(CodableHelper.snakeToCamel("hello_world"), "helloWorld")
        XCTAssertEqual(CodableHelper.snakeToCamel("first_name_last"), "firstNameLast")
        XCTAssertEqual(CodableHelper.snakeToCamel("single"), "single")
        XCTAssertEqual(CodableHelper.camelToSnake("helloWorld"), "hello_world")
        XCTAssertEqual(CodableHelper.camelToSnake("firstNameLast"), "first_name_last")
        XCTAssertEqual(CodableHelper.camelToSnake("single"), "single")
    }
}
