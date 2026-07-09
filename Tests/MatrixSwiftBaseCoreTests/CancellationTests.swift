import XCTest
@testable import MatrixSwiftBaseCore

final class CancellationTests: XCTestCase {

    func testScopeCancelsRunningTask() async {
        let scope = CancellationScope()
        let task = scope.task {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return "done"
        }
        scope.cancel()
        do {
            _ = try await task.value
            XCTFail("expected cancellation")
        } catch {
            XCTAssertTrue(scope.cancelled)
        }
    }

    func testScopeCancelsAllTasks() async {
        let scope = CancellationScope()
        let tasks = (0..<3).map { _ in
            scope.task { try await Task.sleep(nanoseconds: 2_000_000_000) }
        }
        scope.cancel()
        var cancelledCount = 0
        for task in tasks {
            do { _ = try await task.value } catch { cancelledCount += 1 }
        }
        XCTAssertEqual(cancelledCount, 3)
    }

    func testTaskStartedAfterCancelIsCancelled() async {
        let scope = CancellationScope()
        scope.cancel()
        let task = withCancellableTask(in: scope) {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return 1
        }
        do {
            _ = try await task.value
            XCTFail("expected cancellation")
        } catch {
            XCTAssertTrue(scope.cancelled)
        }
    }

    func testUncancelledTaskCompletes() async throws {
        let scope = CancellationScope()
        let task = scope.task { 21 * 2 }
        let value = try await task.value
        XCTAssertEqual(value, 42)
        XCTAssertFalse(scope.cancelled)
    }
}
