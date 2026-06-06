//
//  Endpoint.swift
//  MatrixSwiftBaseCore
//
//  Created by Richard Torcato on 2026-06-06.
//

import Foundation

/// Describes a single HTTP endpoint relative to an `APIClient`'s `baseURL`.
///
/// Conform a type (commonly an enum) per-API and let `APIClient.send(_:)` do
/// the request building and dispatch.
public protocol Endpoint {

    /// Path appended to the client's base URL. May start with `/`.
    var path: String { get }

    /// HTTP method. Defaults to `.get`.
    var method: HTTPMethod { get }

    /// Query string parameters. Defaults to `[]`.
    var queryItems: [URLQueryItem] { get }

    /// Per-request headers. Merged on top of the client's default headers.
    var headers: [String: String] { get }

    /// Request body. Defaults to `.empty`.
    var body: RequestBody { get }

    /// Optional base URL override. When `nil`, the client's `baseURL` is used.
    var baseURL: URL? { get }
}

public extension Endpoint {
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem] { [] }
    var headers: [String: String] { [:] }
    var body: RequestBody { .empty }
    var baseURL: URL? { nil }

    /// Builds a `URLRequest` for this endpoint, merging the supplied base URL,
    /// default headers, and encoder.
    func urlRequest(
        baseURL clientBaseURL: URL,
        defaultHeaders: [String: String] = [:],
        encoder: JSONEncoder = JSONEncoder()
    ) throws -> URLRequest {
        let resolvedBase = baseURL ?? clientBaseURL

        guard var components = URLComponents(
            url: resolvedBase.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL(resolvedBase.appendingPathComponent(path).absoluteString)
        }

        if !queryItems.isEmpty {
            components.queryItems = (components.queryItems ?? []) + queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL(components.string ?? path)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        for (key, value) in defaultHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let encoded = try body.encode(using: encoder) {
            request.httpBody = encoded.data
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue(encoded.contentType, forHTTPHeaderField: "Content-Type")
            }
        }

        return request
    }
}
