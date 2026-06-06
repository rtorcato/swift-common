//
//  EnvHelper.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-06.
//

import Foundation

public final class EnvHelper {

    public init() { }

    /// Read an environment variable as a string. Returns nil when unset.
    public static func string(_ key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }

    /// Read an environment variable as a string, falling back to the given default.
    public static func string(_ key: String, default defaultValue: String) -> String {
        ProcessInfo.processInfo.environment[key] ?? defaultValue
    }

    /// Read an environment variable as an integer. Returns nil when unset or not parseable.
    public static func int(_ key: String) -> Int? {
        guard let raw = ProcessInfo.processInfo.environment[key] else { return nil }
        return Int(raw)
    }

    /// Read an environment variable as an integer, falling back to the given default.
    public static func int(_ key: String, default defaultValue: Int) -> Int {
        int(key) ?? defaultValue
    }

    /// Read an environment variable as a boolean.
    /// Recognises "1", "true", "yes", "on" (case-insensitive) as true; everything else false.
    /// Returns the default when the variable is unset.
    public static func bool(_ key: String, default defaultValue: Bool = false) -> Bool {
        guard let raw = ProcessInfo.processInfo.environment[key]?.lowercased() else { return defaultValue }
        switch raw {
        case "1", "true", "yes", "on": return true
        default: return false
        }
    }

    /// All current environment variables.
    public static var all: [String: String] {
        ProcessInfo.processInfo.environment
    }
}
