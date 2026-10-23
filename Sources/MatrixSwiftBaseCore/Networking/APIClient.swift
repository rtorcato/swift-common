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

    /// Default retry policy applied to every `send`, unless the `Endpoint`
    /// overrides it. Defaults to `.never`.
    public let retryPolicy: RetryPolicy

    public init(
        baseURL: URL,
        session: URLSession = .shared,
        defaultHeaders: [String: String] = [:],
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        interceptor: RequestInterceptor? = nil,
        logger: AppLogger? = nil,
        retryPolicy: RetryPolicy = .never
    ) {
        self.baseURL = baseURL
        self.session = session
        self.defaultHeaders = defaultHeaders
        self.decoder = decoder
        self.encoder = encoder
        self.interceptor = interceptor
        self.logger = logger
        self.retryPolicy = retryPolicy
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

        let policy = endpoint.retryPolicy ?? retryPolicy
        return try await performWithRetry(request: request, policy: policy)
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

    /// Dispatch with retries. Only transient failures (see `NetworkError.isRetryable`)
    /// are retried; a `Retry-After` header overrides the policy's backoff, and
    /// `Task` cancellation is honored between attempts.
    private func performWithRetry(request: URLRequest, policy: RetryPolicy) async throws -> Data {
        var attempt = 0
        while true {
            try Task.checkCancellation()

            let data: Data
            let response: HTTPURLResponse
            do {
                (data, response) = try await performRaw(request: request)
            } catch let error as NetworkError {
                if error.isRetryable, attempt < policy.maxRetries {
                    attempt += 1
                    try await sleepBeforeRetry(attempt: attempt, policy: policy, retryAfter: nil)
                    continue
                }
                throw error
            }

            if (200..<300).contains(response.statusCode) {
                return data
            }

            let httpError = NetworkError.http(statusCode: response.statusCode, data: data)
            if httpError.isRetryable, attempt < policy.maxRetries {
                attempt += 1
                let retryAfter = Self.retryAfterSeconds(from: response)
                try await sleepBeforeRetry(attempt: attempt, policy: policy, retryAfter: retryAfter)
                continue
            }
            logger?.error("HTTP \(response.statusCode) for \(request.url?.absoluteString ?? "-")")
            throw httpError
        }
    }

    /// Perform a single request, returning the raw body and HTTP response.
    /// Throws a mapped `NetworkError` only for transport-level failures.
    private func performRaw(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
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
        return (data, httpResponse)
    }

    private func sleepBeforeRetry(attempt: Int, policy: RetryPolicy, retryAfter: TimeInterval?) async throws {
        let delay = retryAfter ?? policy.delay(forRetry: attempt)
        logger?.debug("retry \(attempt)/\(policy.maxRetries) in \(delay)s")
        guard delay > 0 else { return }
        do {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        } catch {
            throw NetworkError.cancelled
        }
    }

    /// Parse a `Retry-After` header (delta-seconds or HTTP-date) into seconds.
    static func retryAfterSeconds(from response: HTTPURLResponse) -> TimeInterval? {
        guard let value = response.value(forHTTPHeaderField: "Retry-After") else { return nil }
        if let seconds = TimeInterval(value) { return max(0, seconds) }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "GMT")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        if let date = formatter.date(from: value) {
            return max(0, date.timeIntervalSinceNow)
        }
        return nil
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
