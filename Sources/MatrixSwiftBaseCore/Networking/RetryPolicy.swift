//
//  RetryPolicy.swift
//  MatrixSwiftBaseCore
//
//  Configurable retry policy for APIClient. Only transient failures are
//  retried (see NetworkError.isRetryable); a `Retry-After` header always wins
//  over the computed backoff.
//

import Foundation

public struct RetryPolicy: Sendable {

    public enum Backoff: Sendable {
        /// No delay between attempts.
        case none
        /// Constant delay between attempts.
        case fixed(delay: TimeInterval)
        /// Exponential backoff: `base * multiplier^(retry-1)`, ± `jitter` fraction.
        case exponential(base: TimeInterval, multiplier: Double, jitter: Double)
    }

    /// Number of *additional* attempts after the first. `0` means no retries.
    public let maxRetries: Int
    public let backoff: Backoff

    public init(maxRetries: Int, backoff: Backoff) {
        self.maxRetries = max(0, maxRetries)
        self.backoff = backoff
    }

    /// Never retries. (Named `never`, not `none`, so it stays unambiguous when
    /// assigned to an optional `RetryPolicy?` — `.none` there means `nil`.)
    public static let never = RetryPolicy(maxRetries: 0, backoff: .none)

    /// Fixed number of retries with a constant delay.
    public static func fixed(retries: Int, delay: TimeInterval) -> RetryPolicy {
        RetryPolicy(maxRetries: retries, backoff: .fixed(delay: delay))
    }

    /// Exponential backoff with jitter.
    public static func exponentialBackoff(
        retries: Int = 3,
        base: TimeInterval = 0.5,
        multiplier: Double = 2,
        jitter: Double = 0.1
    ) -> RetryPolicy {
        RetryPolicy(maxRetries: retries, backoff: .exponential(base: base, multiplier: multiplier, jitter: jitter))
    }

    /// Delay before the given 1-based retry attempt.
    public func delay(forRetry retry: Int) -> TimeInterval {
        switch backoff {
        case .none:
            return 0
        case .fixed(let delay):
            return max(0, delay)
        case .exponential(let base, let multiplier, let jitter):
            let raw = base * pow(multiplier, Double(max(0, retry - 1)))
            let jitterAmount = raw * jitter * Double.random(in: -1...1)
            return max(0, raw + jitterAmount)
        }
    }
}
