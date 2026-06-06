//
//  APIClient.swift
//  MatrixSwiftBaseCore
//
//  Created by Richard Torcato on 2026-06-06.
//

import Foundation

/// Lightweight async/await HTTP client built around `URLSession` and `Endpoint`.
///
/// ```swift
/// let client = APIClient(baseURL: URL(string: "https://api.example.com")!)
/// let user: User = try await client.send(UserEndpoint.me)
/// ```
public struct APIClient {

    /// Mutates the outgoing `URLRequest` before it is dispatched. Useful for
    /// auth token injection, signing, telemetry headers, etc.
    public typealias RequestInterceptor = @Sendable (inout URLRequest) async throws -> Void

    public let baseURL: URL
    public let session: URLSession
    public let defaultHeaders: [String: String]
    public let decoder: JSONDecoder
    public let encoder: JSONEncoder
    public let interceptor: RequestInterceptor?
    public let logger: AppLogger?

    public init(
        baseURL: URL,
        session: URLSession = .shared,
        defaultHeaders: [String: String] = [:],
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        interceptor: RequestInterceptor? = nil,
        logger: AppLogger? = nil
    ) {
        self.baseURL = baseURL
        self.session = session
        self.defaultHeaders = defaultHeaders
        self.decoder = decoder
        self.encoder = encoder
        self.interceptor = interceptor
        self.logger = logger
    }

    /// Sends an endpoint and decodes the response body as `T`.
    public func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type = T.self) async throws -> T {
        let data = try await send(endpoint)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }

    /// Sends an endpoint and returns the raw response body.
    public func send(_ endpoint: Endpoint) async throws -> Data {
        var request: URLRequest
        do {
            request = try endpoint.urlRequest(
                baseURL: baseURL,
                defaultHeaders: defaultHeaders,
                encoder: encoder
            )
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }

        if let interceptor {
            try await interceptor(&request)
        }

        logger?.debug("\(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "-")")

        return try await perform(request: request)
    }

    /// Fetches raw bytes from an absolute URL using `URLSession.shared`.
    /// Useful for one-off resources (images, downloads) where the full
    /// endpoint abstraction would be overkill.
    public static func fetchData(
        from url: URL,
        session: URLSession = .shared
    ) async throws -> Data {
        let request = URLRequest(url: url)
        return try await perform(request: request, session: session, logger: nil)
    }

    // MARK: - Private

    private func perform(request: URLRequest) async throws -> Data {
        try await Self.perform(request: request, session: session, logger: logger)
    }

    private static func perform(
        request: URLRequest,
        session: URLSession,
        logger: AppLogger?
    ) async throws -> Data {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            let mapped = NetworkError.map(error)
            logger?.error("Request failed: \(mapped.localizedDescription)")
            throw mapped
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            logger?.error("HTTP \(httpResponse.statusCode) for \(request.url?.absoluteString ?? "-")")
            throw NetworkError.http(statusCode: httpResponse.statusCode, data: data)
        }

        return data
    }
}
