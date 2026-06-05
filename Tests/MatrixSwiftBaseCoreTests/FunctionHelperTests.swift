import XCTest
@testable import MatrixSwiftBaseCore

final class FunctionHelperTests: XCTestCase {

    func testDebounceCollapsesRapidCalls() {
        let exp = expectation(description: "fires once")
        let counter = Counter()
        let debounced = FunctionHelper.debounce(0.1) {
            counter.increment()
            exp.fulfill()
        }
        debounced()
        debounced()
        debounced()
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(counter.value, 1)
    }

    func testThrottleFiresFirstCallImmediately() {
        let counter = Counter()
        let throttled = FunctionHelper.throttle(0.5) {
            counter.increment()
        }
        throttled()
        throttled()
        throttled()
        XCTAssertEqual(counter.value, 1)
    }

    func testThrottleFiresAgainAfterWindow() {
        let counter = Counter()
        let throttled = FunctionHelper.throttle(0.05) {
            counter.increment()
        }
        throttled()
        Thread.sleep(forTimeInterval: 0.1)
        throttled()
        XCTAssertEqual(counter.value, 2)
    }

    func testMemoizeCachesResults() {
        let calls = Counter()
        let square = FunctionHelper.memoize { (input: Int) -> Int in
            calls.increment()
            return input * input
        }
        XCTAssertEqual(square(5), 25)
        XCTAssertEqual(square(5), 25)
        XCTAssertEqual(square(5), 25)
        XCTAssertEqual(calls.value, 1)
    }

    func testMemoizeDistinctInputsAreCachedSeparately() {
        let calls = Counter()
        let identity = FunctionHelper.memoize { (input: Int) -> Int in
            calls.increment()
            return input
        }
        _ = identity(1); _ = identity(2); _ = identity(1); _ = identity(2)
        XCTAssertEqual(calls.value, 2)
    }
}

private final class Counter {
    private let lock = NSLock()
    private var _value = 0
    var value: Int {
        lock.lock(); defer { lock.unlock() }
        return _value
    }
    func increment() {
        lock.lock(); defer { lock.unlock() }
        _value += 1
    }
}
