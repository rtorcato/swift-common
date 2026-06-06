import XCTest
@testable import MatrixSwiftBaseCore

private final class MockURLProtocol: URLProtocol {
    nonisolated(unsafe) static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    nonisolated(unsafe) static var lastRequest: URLRequest?

    override static func canInit(with request: URLRequest) -> Bool { true }
    override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        MockURLProtocol.lastRequest = request
        guard let handler = MockURLProtocol.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.unknown))
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data { client?.urlProtocol(self, didLoad: data) }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

private struct GetUser: Endpoint {
    let path = "/users/1"
}

private struct PostUser: Endpoint {
    struct Payload: Encodable { let name: String }
    let path = "/users"
    let method = HTTPMethod.post
    let body: RequestBody
    init(name: String) { self.body = .json(Payload(name: name)) }
}

private struct User: Decodable, Equatable {
    let id: Int
    let name: String
}

final class APIClientTests: XCTestCase {

    private let base = URL(string: "https://api.example.com")!

    private func makeClient(
        defaultHeaders: [String: String] = [:],
        interceptor: APIClient.RequestInterceptor? = nil
    ) -> APIClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return APIClient(
            baseURL: base,
            session: session,
            defaultHeaders: defaultHeaders,
            interceptor: interceptor
        )
    }

    override func tearDown() {
        MockURLProtocol.handler = nil
        MockURLProtocol.lastRequest = nil
        super.tearDown()
    }

    func testSendDecodesResponse() async throws {
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            let data = Data(#"{"id":1,"name":"Ada"}"#.utf8)
            return (response, data)
        }

        let client = makeClient()
        let user: User = try await client.send(GetUser())
        XCTAssertEqual(user, User(id: 1, name: "Ada"))
        XCTAssertEqual(MockURLProtocol.lastRequest?.url?.absoluteString, "https://api.example.com/users/1")
        XCTAssertEqual(MockURLProtocol.lastRequest?.httpMethod, "GET")
    }

    func testSendMapsNon2xxToHTTPError() async {
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data("not found".utf8))
        }

        let client = makeClient()
        do {
            let _: User = try await client.send(GetUser())
            XCTFail("expected error")
        } catch let error as NetworkError {
            XCTAssertEqual(error.statusCode, 404)
            if case .http(_, let data) = error {
                XCTAssertEqual(data.map { String(data: $0, encoding: .utf8) }, "not found")
            } else {
                XCTFail("expected .http")
            }
        } catch {
            XCTFail("expected NetworkError, got \(error)")
        }
    }

    func testSendMapsDecodingError() async {
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data("not json".utf8))
        }

        let client = makeClient()
        do {
            let _: User = try await client.send(GetUser())
            XCTFail("expected error")
        } catch let error as NetworkError {
            if case .decoding = error {} else {
                XCTFail("expected .decoding, got \(error)")
            }
        } catch {
            XCTFail("expected NetworkError, got \(error)")
        }
    }

    func testInterceptorInjectsHeader() async throws {
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data(#"{"id":2,"name":"Bob"}"#.utf8))
        }

        let client = makeClient { request in
            request.setValue("Bearer token-xyz", forHTTPHeaderField: "Authorization")
        }
        let _: User = try await client.send(GetUser())
        XCTAssertEqual(
            MockURLProtocol.lastRequest?.value(forHTTPHeaderField: "Authorization"),
            "Bearer token-xyz"
        )
    }

    func testDefaultHeadersApplied() async throws {
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data(#"{"id":3,"name":"C"}"#.utf8))
        }

        let client = makeClient(defaultHeaders: ["X-Client": "swift-common"])
        let _: User = try await client.send(GetUser())
        XCTAssertEqual(
            MockURLProtocol.lastRequest?.value(forHTTPHeaderField: "X-Client"),
            "swift-common"
        )
    }

    func testPostEncodesJSONBody() async throws {
        MockURLProtocol.handler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data(#"{"id":4,"name":"Ada"}"#.utf8))
        }

        let client = makeClient()
        let _: User = try await client.send(PostUser(name: "Ada"))

        // URLProtocol strips httpBody and exposes it via httpBodyStream; verify method + headers.
        XCTAssertEqual(MockURLProtocol.lastRequest?.httpMethod, "POST")
        XCTAssertEqual(
            MockURLProtocol.lastRequest?.value(forHTTPHeaderField: "Content-Type"),
            "application/json"
        )
    }

    func testTransportErrorMapped() async {
        MockURLProtocol.handler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        let client = makeClient()
        do {
            let _: User = try await client.send(GetUser())
            XCTFail("expected error")
        } catch let error as NetworkError {
            if case .transport(let inner) = error {
                XCTAssertEqual(inner.code, .notConnectedToInternet)
            } else {
                XCTFail("expected .transport, got \(error)")
            }
        } catch {
            XCTFail("expected NetworkError, got \(error)")
        }
    }
}
