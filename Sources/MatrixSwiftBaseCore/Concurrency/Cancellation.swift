//
//  Cancellation.swift
//  MatrixSwiftBaseCore
//
//  An AbortController-equivalent for Swift Concurrency: hand tasks to a scope,
//  then cancel them all from the outside — even tasks the caller doesn't own.
//

import Foundation

/// A logical scope that owns and can cancel a group of tasks, analogous to
/// JavaScript's `AbortController` + `AbortSignal`.
///
///     let scope = CancellationScope()
///     let task = scope.task { try await load() }
///     // later, from anywhere:
///     scope.cancel()   // cancels `task` and every other task in the scope
public final class CancellationScope: @unchecked Sendable {

    private let lock = NSLock()
    private var tasks: [() -> Void] = []
    private var isCancelled = false

    public init() { }

    /// Whether `cancel()` has been called.
    public var cancelled: Bool {
        lock.lock(); defer { lock.unlock() }
        return isCancelled
    }

    /// Start an async operation tied to this scope. The returned `Task` can be
    /// awaited normally; cancelling the scope cancels it. A task started after
    /// the scope is already cancelled is cancelled immediately.
    @discardableResult
    public func task<T>(_ operation: @escaping @Sendable () async throws -> T) -> Task<T, Error> {
        let task = Task { try await operation() }
        lock.lock()
        if isCancelled {
            lock.unlock()
            task.cancel()
        } else {
            tasks.append { task.cancel() }
            lock.unlock()
        }
        return task
    }

    /// Cancel every task started in this scope, now and for the rest of its life.
    public func cancel() {
        lock.lock()
        isCancelled = true
        let cancellations = tasks
        tasks.removeAll()
        lock.unlock()
        cancellations.forEach { $0() }
    }
}

/// Run `operation` as a task tied to `scope`, returning the `Task` so the caller
/// can await its result while retaining the ability to cancel from outside.
@discardableResult
public func withCancellableTask<T>(
    in scope: CancellationScope,
    _ operation: @escaping @Sendable () async throws -> T
) -> Task<T, Error> {
    scope.task(operation)
}
