import XCTest
import Combine
@testable import MatrixSwiftBaseCore

private struct TestEvent: Event { let value: String }
private struct OtherEvent: Event { }

/// Thread-safe recorder for values seen by `@Sendable` handlers.
private final class Recorder<T: Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var storage: [T] = []
    func append(_ value: T) { lock.lock(); storage.append(value); lock.unlock() }
    var values: [T] { lock.lock(); defer { lock.unlock() }; return storage }
}

final class EventBusTests: XCTestCase {

    func testOnReceivesEmittedEvent() {
        let bus = EventBus()
        let received = Recorder<String>()
        let token = bus.on(TestEvent.self) { received.append($0.value) }
        bus.emit(TestEvent(value: "hi"))
        XCTAssertEqual(received.values, ["hi"])
        bus.off(token)
    }

    func testOffStopsDelivery() {
        let bus = EventBus()
        let received = Recorder<String>()
        let token = bus.on(TestEvent.self) { received.append($0.value) }
        bus.emit(TestEvent(value: "a"))
        bus.off(token)
        bus.emit(TestEvent(value: "b"))
        XCTAssertEqual(received.values, ["a"])
    }

    func testOnlyMatchingTypeIsDelivered() {
        let bus = EventBus()
        let received = Recorder<String>()
        bus.on(TestEvent.self) { received.append($0.value) }
        bus.emit(OtherEvent())
        XCTAssertTrue(received.values.isEmpty)
    }

    func testMultipleListenersEachReceive() {
        let bus = EventBus()
        let first = Recorder<String>()
        let second = Recorder<String>()
        bus.on(TestEvent.self) { first.append($0.value) }
        bus.on(TestEvent.self) { second.append($0.value) }
        bus.emit(TestEvent(value: "x"))
        XCTAssertEqual(first.values, ["x"])
        XCTAssertEqual(second.values, ["x"])
    }

    func testPublisherDeliversTypedEvents() {
        let bus = EventBus()
        var values: [String] = []
        let cancellable = bus.publisher(for: TestEvent.self).sink { values.append($0.value) }
        bus.emit(TestEvent(value: "p"))
        bus.emit(OtherEvent())
        XCTAssertEqual(values, ["p"])
        cancellable.cancel()
    }

    func testConcurrentSubscribeEmitAndOff() {
        let bus = EventBus()
        let received = Recorder<String>()
        DispatchQueue.concurrentPerform(iterations: 200) { i in
            let token = bus.on(TestEvent.self) { received.append($0.value) }
            bus.emit(TestEvent(value: "\(i)"))
            bus.off(token)
        }
        // Every iteration's own listener saw at least its own event.
        XCTAssertGreaterThanOrEqual(received.values.count, 200)
    }
}
