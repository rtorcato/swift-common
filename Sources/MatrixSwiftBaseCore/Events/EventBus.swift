//
//  EventBus.swift
//  MatrixSwiftBase
//
//  A typed, Combine-backed event bus — the Swift-idiomatic replacement for
//  stringly-typed NotificationCenter wrappers. Conform a type to `Event`,
//  then `emit` / `on` / `off` it.
//
//      struct UserLoggedIn: Event { let userID: String }
//      let token = EventBus.shared.on(UserLoggedIn.self) { print($0.userID) }
//      EventBus.shared.emit(UserLoggedIn(userID: "abc"))
//      EventBus.shared.off(token)
//

import Foundation
import Combine

/// Marker protocol for anything published on an `EventBus`.
public protocol Event { }

/// Opaque handle to a subscription. Keep it and pass it to `off(_:)` to stop listening.
public final class EventToken {
    public init() { }
}

public final class EventBus {

    public static let shared = EventBus()

    public init() { }

    private let subject = PassthroughSubject<Event, Never>()
    private var subscriptions: [ObjectIdentifier: AnyCancellable] = [:]
    // ponytail: single lock guarding the subscription map; fine for UI-scale event volume.
    // Swap for finer-grained locking only if a hot path shows contention.
    private let lock = NSLock()

    /// Publish an event to every matching listener.
    public func emit(_ event: Event) {
        subject.send(event)
    }

    /// A Combine publisher of a single event type — use when you want to compose with Combine directly.
    public func publisher<E: Event>(for type: E.Type) -> AnyPublisher<E, Never> {
        subject.compactMap { $0 as? E }.eraseToAnyPublisher()
    }

    /// Subscribe to an event type. The bus retains the subscription until you call `off(_:)`.
    @discardableResult
    public func on<E: Event>(_ type: E.Type, _ handler: @escaping (E) -> Void) -> EventToken {
        let token = EventToken()
        let cancellable = publisher(for: type).sink(receiveValue: handler)
        lock.lock()
        subscriptions[ObjectIdentifier(token)] = cancellable
        lock.unlock()
        return token
    }

    /// Cancel a subscription created by `on(_:_:)`.
    public func off(_ token: EventToken) {
        lock.lock()
        subscriptions[ObjectIdentifier(token)] = nil
        lock.unlock()
    }
}
