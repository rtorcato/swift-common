import XCTest
@testable import MatrixSwiftBaseCore

final class SleepHelperTests: XCTestCase {

    func testMillisecondsActuallySleeps() async throws {
        let start = Date()
        try await SleepHelper.milliseconds(50)
        let elapsed = Date().timeIntervalSince(start)
        XCTAssertGreaterThanOrEqual(elapsed, 0.04)
    }

    func testSecondsFractional() async throws {
        let start = Date()
        try await SleepHelper.seconds(0.05)
        let elapsed = Date().timeIntervalSince(start)
        XCTAssertGreaterThanOrEqual(elapsed, 0.04)
    }

    func testCancellationThrows() async {
        let task = Task {
            try await SleepHelper.seconds(5.0)
        }
        task.cancel()
        do {
            try await task.value
            XCTFail("Expected cancellation to throw")
        } catch {
            XCTAssertTrue(error is CancellationError)
        }
    }
}
