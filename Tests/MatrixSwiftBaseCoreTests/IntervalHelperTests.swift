import XCTest
@testable import MatrixSwiftBaseCore

final class IntervalHelperTests: XCTestCase {

    func testEveryFiresAndStops() async {
        let counter = AsyncCounter()
        let task = IntervalHelper.every(0.05) {
            await counter.increment()
        }
        try? await Task.sleep(nanoseconds: 250_000_000)
        task.cancel()
        let count = await counter.value
        XCTAssertGreaterThanOrEqual(count, 2)
        XCTAssertLessThanOrEqual(count, 10)
    }

    func testEveryStopsImmediatelyAfterCancel() async {
        let counter = AsyncCounter()
        let task = IntervalHelper.every(0.1) {
            await counter.increment()
        }
        task.cancel()
        try? await Task.sleep(nanoseconds: 200_000_000)
        let count = await counter.value
        XCTAssertLessThanOrEqual(count, 1)
    }

    func testAfterRunsOnce() async {
        let counter = AsyncCounter()
        let task = IntervalHelper.after(0.05) {
            await counter.increment()
        }
        try? await Task.sleep(nanoseconds: 150_000_000)
        task.cancel()
        let count = await counter.value
        XCTAssertEqual(count, 1)
    }

    func testAfterCancelledBeforeFiringDoesNotRun() async {
        let counter = AsyncCounter()
        let task = IntervalHelper.after(0.5) {
            await counter.increment()
        }
        task.cancel()
        try? await Task.sleep(nanoseconds: 100_000_000)
        let count = await counter.value
        XCTAssertEqual(count, 0)
    }
}

private actor AsyncCounter {
    private var _value = 0
    var value: Int { _value }
    func increment() { _value += 1 }
}
