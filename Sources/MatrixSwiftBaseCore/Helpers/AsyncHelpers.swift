//
//  AsyncHelpers.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-05.
//

import Foundation

public struct TimeoutError: Error, Equatable {
    public init() { }
}

public final class AsyncHelpers {

    public init() { }

    /// Retry an async-throwing operation up to `attempts` times, sleeping `delay`
    /// seconds between tries. Returns the first successful result, or throws the
    /// last error after all attempts are exhausted.
    public static func retry<T: Sendable>(
        attempts: Int,
        delay: Double = 0,
        operation: @Sendable () async throws -> T
    ) async throws -> T {
        precondition(attempts > 0, "attempts must be > 0")
        var lastError: Error?
        for attempt in 1...attempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                if attempt < attempts, delay > 0 {
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }
        // Safe: at least one error was captured because attempts > 0.
        throw lastError ?? TimeoutError()
    }

    /// Run `operation` with a timeout. Throws `TimeoutError` if it doesn't complete
    /// within `seconds`.
    public static func withTimeout<T: Sendable>(
        _ seconds: Double,
        operation: @Sendable @escaping () async throws -> T
    ) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask { try await operation() }
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                throw TimeoutError()
            }
            guard let result = try await group.next() else { throw TimeoutError() }
            group.cancelAll()
            return result
        }
    }
}
