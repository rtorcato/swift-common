import XCTest
@testable import MatrixSwiftBaseCore

final class NetworkErrorTests: XCTestCase {

    func testInvalidURLDescription() {
        let error = NetworkError.invalidURL("not a url")
        XCTAssertEqual(error.errorDescription, "Invalid URL: not a url")
    }

    func testHTTPDescriptionAndStatusCode() {
        let error = NetworkError.http(statusCode: 503, data: nil)
        XCTAssertEqual(error.errorDescription, "HTTP 503")
        XCTAssertEqual(error.statusCode, 503)
    }

    func testStatusCodeNilForNonHTTPCases() {
        XCTAssertNil(NetworkError.invalidResponse.statusCode)
        XCTAssertNil(NetworkError.cancelled.statusCode)
    }

    func testCancelledDescription() {
        XCTAssertEqual(NetworkError.cancelled.errorDescription, "Request cancelled")
    }

    func testMapPassesThroughNetworkError() {
        let original = NetworkError.http(statusCode: 404, data: nil)
        let mapped = NetworkError.map(original)
        XCTAssertEqual(mapped.statusCode, 404)
    }

    func testMapURLErrorBecomesTransport() {
        let urlError = URLError(.notConnectedToInternet)
        let mapped = NetworkError.map(urlError)
        if case .transport(let inner) = mapped {
            XCTAssertEqual(inner.code, .notConnectedToInternet)
        } else {
            XCTFail("expected .transport, got \(mapped)")
        }
    }

    func testMapURLErrorCancelledBecomesCancelled() {
        let urlError = URLError(.cancelled)
        let mapped = NetworkError.map(urlError)
        if case .cancelled = mapped {} else {
            XCTFail("expected .cancelled, got \(mapped)")
        }
    }

    func testMapCancellationErrorBecomesCancelled() {
        let mapped = NetworkError.map(CancellationError())
        if case .cancelled = mapped {} else {
            XCTFail("expected .cancelled, got \(mapped)")
        }
    }
}
