import XCTest
@testable import MatrixSwiftBaseCore

private struct SimpleGet: Endpoint {
    let path: String
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]
}

private struct JSONPost: Endpoint {
    struct Payload: Encodable { let name: String }
    let path = "/users"
    let method = HTTPMethod.post
    let body: RequestBody
    init(name: String) { self.body = .json(Payload(name: name)) }
}

private struct FormPost: Endpoint {
    let path = "/login"
    let method = HTTPMethod.post
    let body: RequestBody = .form([
        URLQueryItem(name: "user", value: "ada"),
        URLQueryItem(name: "pass", value: "lovelace")
    ])
}

private struct OverrideBase: Endpoint {
    let path = "/health"
    let baseURL: URL? = URL(string: "https://other.example.com")
}

final class EndpointTests: XCTestCase {

    private let base = URL(string: "https://api.example.com")!

    func testBasicGetURL() throws {
        let request = try SimpleGet(path: "/v1/ping").urlRequest(baseURL: base)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/v1/ping")
        XCTAssertNil(request.httpBody)
    }

    func testQueryItemsAppended() throws {
        let endpoint = SimpleGet(
            path: "/search",
            queryItems: [URLQueryItem(name: "q", value: "swift")]
        )
        let request = try endpoint.urlRequest(baseURL: base)
        XCTAssertEqual(request.url?.absoluteString, "https://api.example.com/search?q=swift")
    }

    func testHeadersMergeOverDefaults() throws {
        let endpoint = SimpleGet(
            path: "/me",
            headers: ["Authorization": "Bearer abc", "X-Request-Id": "1"]
        )
        let request = try endpoint.urlRequest(
            baseURL: base,
            defaultHeaders: ["X-Request-Id": "default", "Accept": "application/json"]
        )
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer abc")
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Request-Id"), "1")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
    }

    func testJSONBodyEncodesAndSetsContentType() throws {
        let request = try JSONPost(name: "Ada").urlRequest(baseURL: base)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        let body = try XCTUnwrap(request.httpBody)
        let decoded = try JSONDecoder().decode([String: String].self, from: body)
        XCTAssertEqual(decoded, ["name": "Ada"])
    }

    func testFormBodyURLEncodes() throws {
        let request = try FormPost().urlRequest(baseURL: base)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        let body = try XCTUnwrap(request.httpBody)
        XCTAssertEqual(String(data: body, encoding: .utf8), "user=ada&pass=lovelace")
    }

    func testBaseURLOverride() throws {
        let request = try OverrideBase().urlRequest(baseURL: base)
        XCTAssertEqual(request.url?.absoluteString, "https://other.example.com/health")
    }

    func testDataBodyDefaultsContentType() throws {
        struct Raw: Endpoint {
            let path = "/upload"
            let method = HTTPMethod.put
            let body: RequestBody = .data(Data([0x01, 0x02]), contentType: "application/x-binary")
        }
        let request = try Raw().urlRequest(baseURL: base)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/x-binary")
        XCTAssertEqual(request.httpBody, Data([0x01, 0x02]))
    }
}
