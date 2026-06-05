import XCTest
@testable import MatrixSwiftBaseCore

final class AsyncHelpersTests: XCTestCase {

    func testRetrySucceedsOnFirstTry() async throws {
        let attempts = AsyncCounter()
        let result = try await AsyncHelpers.retry(attempts: 3) {
            await attempts.increment()
            return "ok"
        }
        let count = await attempts.value
        XCTAssertEqual(result, "ok")
        XCTAssertEqual(count, 1)
    }

    func testRetrySucceedsAfterFailure() async throws {
        let attempts = AsyncCounter()
        let result = try await AsyncHelpers.retry(attempts: 3) {
            await attempts.increment()
            let count = await attempts.value
            if count < 2 { throw SampleError.fail }
            return "ok"
        }
        let final = await attempts.value
        XCTAssertEqual(result, "ok")
        XCTAssertEqual(final, 2)
    }

    func testRetryExhaustsThenThrows() async {
        let attempts = AsyncCounter()
        do {
            _ = try await AsyncHelpers.retry(attempts: 3) {
                await attempts.increment()
                throw SampleError.fail
            }
            XCTFail("expected to throw")
        } catch {
            let count = await attempts.value
            XCTAssertEqual(count, 3)
            XCTAssertTrue(error is SampleError)
        }
    }

    func testWithTimeoutReturnsValueWhenFastEnough() async throws {
        let result = try await AsyncHelpers.withTimeout(1.0) {
            try await Task.sleep(nanoseconds: 50_000_000)
            return 42
        }
        XCTAssertEqual(result, 42)
    }

    func testWithTimeoutThrowsTimeoutError() async {
        do {
            _ = try await AsyncHelpers.withTimeout(0.05) {
                try await Task.sleep(nanoseconds: 500_000_000)
                return "should not reach"
            }
            XCTFail("expected TimeoutError")
        } catch {
            XCTAssertTrue(error is TimeoutError)
        }
    }
}

private enum SampleError: Error {
    case fail
}

private actor AsyncCounter {
    private var _value = 0
    var value: Int { _value }
    func increment() { _value += 1 }
}
