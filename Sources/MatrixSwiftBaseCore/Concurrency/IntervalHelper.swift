//
//  IntervalHelper.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-06.
//

import Foundation

public final class IntervalHelper {

    public init() { }

    /// Run `action` repeatedly, waiting `seconds` between invocations.
    /// Cancel the returned `Task` to stop the loop. The first invocation happens
    /// immediately; subsequent invocations are spaced by `seconds`.
    public static func every(
        _ seconds: Double,
        _ action: @Sendable @escaping () async -> Void
    ) -> Task<Void, Never> {
        Task {
            while !Task.isCancelled {
                await action()
                do {
                    try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                } catch {
                    return
                }
            }
        }
    }

    /// Run `action` once after `seconds`. Cancel the returned `Task` to suppress it.
    public static func after(
        _ seconds: Double,
        _ action: @Sendable @escaping () async -> Void
    ) -> Task<Void, Never> {
        Task {
            do {
                try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            await action()
        }
    }
}
