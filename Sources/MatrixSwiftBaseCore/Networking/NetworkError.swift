//
//  NetworkError.swift
//  MatrixSwiftBaseCore
//
//  Created by Richard Torcato on 2022-11-25.
//

import Foundation

/// Errors emitted by `APIClient` and friends.
public enum NetworkError: LocalizedError {

    case invalidURL(String)
    case invalidResponse
    case http(statusCode: Int, data: Data?)
    case decoding(Error)
    case encoding(Error)
    case transport(URLError)
    case cancelled
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL(let value):
            return "Invalid URL: \(value)"
        case .invalidResponse:
            return "Invalid response from server"
        case .http(let code, _):
            return "HTTP \(code)"
        case .decoding(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .encoding(let error):
            return "Encoding failed: \(error.localizedDescription)"
        case .transport(let error):
            return error.localizedDescription
        case .cancelled:
            return "Request cancelled"
        case .unknown(let error):
            return error.localizedDescription
        }
    }

    /// HTTP status code if this is an `.http` error, otherwise nil.
    public var statusCode: Int? {
        if case .http(let code, _) = self { return code }
        return nil
    }

    /// Whether this error is transient and worth retrying: 5xx / 429 responses
    /// and recoverable transport failures (timeouts, dropped connections).
    public var isRetryable: Bool {
        switch self {
        case .http(let code, _):
            return code == 429 || (500..<600).contains(code)
        case .transport(let urlError):
            switch urlError.code {
            case .timedOut, .networkConnectionLost, .cannotConnectToHost,
                 .dnsLookupFailed, .notConnectedToInternet, .cannotFindHost:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }

    /// Maps an arbitrary `Error` to a `NetworkError`, preserving `URLError`
    /// and cancellation semantics.
    public static func map(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }
        if let urlError = error as? URLError {
            return urlError.code == .cancelled ? .cancelled : .transport(urlError)
        }
        if error is CancellationError {
            return .cancelled
        }
        return .unknown(error)
    }
}
