//
//  AppLogger.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-06.
//

import Foundation
import os

/// Thin wrapper around `os.Logger` that gives downstream apps a consistent
/// subsystem/category surface and level-tagged convenience methods.
/// Named `AppLogger` to avoid shadowing the stdlib `Logger` typealias.
public struct AppLogger {

    private let underlying: os.Logger

    public init(subsystem: String, category: String) {
        self.underlying = os.Logger(subsystem: subsystem, category: category)
    }

    public func debug(_ message: String) {
        underlying.debug("\(message, privacy: .public)")
    }

    public func info(_ message: String) {
        underlying.info("\(message, privacy: .public)")
    }

    public func notice(_ message: String) {
        underlying.notice("\(message, privacy: .public)")
    }

    public func warning(_ message: String) {
        underlying.warning("\(message, privacy: .public)")
    }

    public func error(_ message: String) {
        underlying.error("\(message, privacy: .public)")
    }

    public func critical(_ message: String) {
        underlying.critical("\(message, privacy: .public)")
    }
}
