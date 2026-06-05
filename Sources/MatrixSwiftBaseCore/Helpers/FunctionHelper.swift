//
//  FunctionHelper.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-05.
//

import Foundation

public final class FunctionHelper {

    public init() { }

    /// Returns a closure that delays invoking `action` until `interval` seconds
    /// have passed without further calls. Cancels the pending call if invoked again.
    /// Thread-safe; runs `action` on the main queue.
    public static func debounce(_ interval: TimeInterval, action: @escaping () -> Void) -> () -> Void {
        var workItem: DispatchWorkItem?
        let lock = NSLock()
        return {
            lock.lock(); defer { lock.unlock() }
            workItem?.cancel()
            let item = DispatchWorkItem(block: action)
            workItem = item
            DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: item)
        }
    }

    /// Returns a closure that invokes `action` at most once every `interval` seconds.
    /// The first call fires immediately; subsequent calls within the window are dropped.
    /// Thread-safe.
    public static func throttle(_ interval: TimeInterval, action: @escaping () -> Void) -> () -> Void {
        var lastFire: Date?
        let lock = NSLock()
        return {
            lock.lock()
            let now = Date()
            if let last = lastFire, now.timeIntervalSince(last) < interval {
                lock.unlock()
                return
            }
            lastFire = now
            lock.unlock()
            action()
        }
    }

    /// Returns a closure that caches results of `compute` keyed by its `Hashable` input.
    /// Thread-safe.
    public static func memoize<Input: Hashable, Output>(
        _ compute: @escaping (Input) -> Output
    ) -> (Input) -> Output {
        var cache: [Input: Output] = [:]
        let lock = NSLock()
        return { input in
            lock.lock(); defer { lock.unlock() }
            if let cached = cache[input] { return cached }
            let value = compute(input)
            cache[input] = value
            return value
        }
    }
}
