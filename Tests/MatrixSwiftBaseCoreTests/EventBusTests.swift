import XCTest
@testable import MatrixSwiftBaseCore

private struct TestEvent: Event { let value: String }
private struct OtherEvent: Event { }

final class EventBusTests: XCTestCase {

    func testOnReceivesEmittedEvent() {
        let bus = EventBus()
        var received: String?
        let token = bus.on(TestEvent.self) { received = $0.value }
        bus.emit(TestEvent(value: "hi"))
        XCTAssertEqual(received, "hi")
        bus.off(token)
    }

    func testOffStopsDelivery() {
        let bus = EventBus()
        var count = 0
        let token = bus.on(TestEvent.self) { _ in count += 1 }
        bus.emit(TestEvent(value: "a"))
        bus.off(token)
        bus.emit(TestEvent(value: "b"))
        XCTAssertEqual(count, 1)
    }

    func testOnlyMatchingTypeIsDelivered() {
        let bus = EventBus()
        var got = 0
        bus.on(TestEvent.self) { _ in got += 1 }
        bus.emit(OtherEvent())
        XCTAssertEqual(got, 0)
    }
}
