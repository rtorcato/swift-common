//
//  AppError.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-05.
//

import Foundation

/// A general-purpose `LocalizedError` for app and library code.
/// Wraps a stable string code, a user-facing message, and optional info payload.
public struct AppError: LocalizedError, Equatable {

    public let code: String
    public let message: String
    public let userInfo: [String: String]

    public init(code: String, message: String, userInfo: [String: String] = [:]) {
        self.code = code
        self.message = message
        self.userInfo = userInfo
    }

    public var errorDescription: String? { message }

    public static func == (lhs: AppError, rhs: AppError) -> Bool {
        lhs.code == rhs.code && lhs.message == rhs.message && lhs.userInfo == rhs.userInfo
    }
}

public extension Result {

    /// Run a throwing closure and wrap success/failure into a `Result`.
    /// Mirrors the JS `try` helper from rtorcato/js-common.
    static func tryCatch(_ body: () throws -> Success) -> Result<Success, Error> {
        do { return .success(try body()) } catch { return .failure(error) }
    }

    /// Async variant.
    static func tryCatch(_ body: () async throws -> Success) async -> Result<Success, Error> {
        do { return .success(try await body()) } catch { return .failure(error) }
    }
}
