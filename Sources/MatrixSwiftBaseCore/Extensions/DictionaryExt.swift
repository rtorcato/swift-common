//
//  DictionaryExt.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-06.
//

import Foundation

public extension Dictionary {

    /// Map keys to a new `Hashable` type, keeping values unchanged.
    /// If the transform produces duplicate keys, the last-seen value wins.
    func mapKeys<NewKey: Hashable>(_ transform: (Key) -> NewKey) -> [NewKey: Value] {
        var result: [NewKey: Value] = [:]
        result.reserveCapacity(count)
        for (key, value) in self {
            result[transform(key)] = value
        }
        return result
    }

    /// Sugar over `filter` for keeping only entries whose key matches the predicate.
    func filteringKeys(_ isIncluded: (Key) -> Bool) -> [Key: Value] {
        filter { isIncluded($0.key) }
    }
}

public extension Dictionary where Key == String {

    /// Return the dictionary with every key converted from `snake_case` to `camelCase`.
    /// e.g. `["first_name": "Jane"]` becomes `["firstName": "Jane"]`.
    func keysToCamelCase() -> [String: Value] {
        mapKeys { key in
            let parts = key.split(separator: "_", omittingEmptySubsequences: false)
            guard let first = parts.first else { return key }
            let tail = parts.dropFirst().map { $0.capitalized }
            return ([String(first)] + tail).joined()
        }
    }

    /// Return the dictionary with every key converted from `camelCase` to `snake_case`.
    func keysToSnakeCase() -> [String: Value] {
        mapKeys { key in
            var result = ""
            for character in key {
                if character.isUppercase {
                    if !result.isEmpty { result.append("_") }
                    result.append(Character(character.lowercased()))
                } else {
                    result.append(character)
                }
            }
            return result
        }
    }
}
