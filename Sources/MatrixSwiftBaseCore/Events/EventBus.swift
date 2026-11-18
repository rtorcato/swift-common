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

/// Marker protocol for anything published on an `EventBus`. Events cross
/// threads (they are delivered on the emitter's thread), so they must be `Sendable`.
public protocol Event: Sendable { }

/// Opaque handle to a subscription. Keep it and pass it to `off(_:)` to stop listening.
public final class EventToken: Hashable, Sendable {
    // A stable ID rather than ObjectIdentifier: a discarded token is freed and
    // its address reused, which would let a later `on` overwrite this subscription.
    let id = UUID()

    public init() { }

    public static func == (lhs: EventToken, rhs: EventToken) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// Handlers run synchronously on the thread that calls `emit`. For UI work,
/// hop to the main actor inside the handler, or use
/// `publisher(for:).receive(on: DispatchQueue.main)`.
///
/// `@unchecked Sendable`: the only mutable state, `subscriptions`, is guarded by
/// `lock`, and `PassthroughSubject.send` is safe to call from any thread.
public final class EventBus: @unchecked Sendable {

    public static let shared = EventBus()

    public init() { }

    private let subject = PassthroughSubject<Event, Never>()
    private var subscriptions: [UUID: AnyCancellable] = [:]
    // A single lock guards the subscription map; fine for UI-scale event volume.
    private let lock = NSLock()

    /// Publish an event to every matching listener.
    public func emit(_ event: Event) {
        subject.send(event)
    }

    /// A Combine publisher of a single event type — use when you want to compose with Combine directly.
    public func publisher<E: Event>(for type: E.Type) -> AnyPublisher<E, Never> {
        subject.compactMap { $0 as? E }.eraseToAnyPublisher()
    }

    /// Subscribe to an event type. The bus retains the subscription until you call `off(_:)`;
    /// discarding the token keeps the listener for the bus's lifetime.
    @discardableResult
    public func on<E: Event>(_ type: E.Type, _ handler: @escaping @Sendable (E) -> Void) -> EventToken {
        let token = EventToken()
        let cancellable = publisher(for: type).sink(receiveValue: handler)
        lock.lock()
        defer { lock.unlock() }
        subscriptions[token.id] = cancellable
        return token
    }

    /// Cancel a subscription created by `on(_:_:)`.
    public func off(_ token: EventToken) {
        lock.lock()
        let cancellable = subscriptions.removeValue(forKey: token.id)
        lock.unlock()
        // Cancel outside the lock so a handler that calls back into the bus can't deadlock.
        cancellable?.cancel()
    }
}
