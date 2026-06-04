//
//  SleepHelper.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-04.
//

import Foundation

public final class SleepHelper {

    public init() { }

    /// Suspend the current task for the given number of seconds (supports fractional values).
    public static func seconds(_ seconds: Double) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }

    /// Suspend the current task for the given number of milliseconds.
    public static func milliseconds(_ milliseconds: Int) async throws {
        try await Task.sleep(nanoseconds: UInt64(milliseconds) * 1_000_000)
    }

    /// Suspend the current task for the given number of nanoseconds.
    public static func nanoseconds(_ nanoseconds: UInt64) async throws {
        try await Task.sleep(nanoseconds: nanoseconds)
    }
}
