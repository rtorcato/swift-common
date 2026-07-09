//
//  CodableHelper.swift
//  MatrixSwiftBase
//
//  JSON ergonomics that JS apps reach for daily. JsonHelper stays the thin
//  bundle-loading wrapper; this is where the reusable JSON logic lives.
//

import Foundation

public enum CodableHelper {

    // MARK: - Partial decode

    /// Pull a single typed value from a dot-separated key path in JSON data,
    /// ignoring everything else — no throwaway `Codable` struct required.
    ///
    ///     CodableHelper.value(String.self, at: "user.name", in: data)
    public static func value<T>(_ type: T.Type = T.self, at keyPath: String, in data: Data) -> T? {
        guard let object = try? JSONSerialization.jsonObject(with: data) else { return nil }
        var current: Any? = object
        for key in keyPath.split(separator: ".") {
            current = (current as? [String: Any])?[String(key)]
        }
        return current as? T
    }

    // MARK: - Key omission

    /// Encode a value, then drop the given top-level keys from the JSON object.
    public static func encode<T: Encodable>(
        _ value: T,
        omitting keys: Set<String>,
        encoder: JSONEncoder = JSONEncoder()
    ) -> Data? {
        guard let data = try? encoder.encode(value),
              var object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
            return nil
        }
        for key in keys { object.removeValue(forKey: key) }
        return try? JSONSerialization.data(withJSONObject: object)
    }

    // MARK: - Deep merge

    /// Recursively merge two JSON dictionaries. Nested dictionaries merge;
    /// for every other value, `override` wins.
    public static func deepMerge(_ base: [String: Any], _ override: [String: Any]) -> [String: Any] {
        var result = base
        for (key, overrideValue) in override {
            if let baseDict = result[key] as? [String: Any],
               let overrideDict = overrideValue as? [String: Any] {
                result[key] = deepMerge(baseDict, overrideDict)
            } else {
                result[key] = overrideValue
            }
        }
        return result
    }

    // MARK: - Key-case conversion

    /// `"hello_world"` → `"helloWorld"`.
    public static func snakeToCamel(_ string: String) -> String {
        let parts = string.split(separator: "_", omittingEmptySubsequences: false)
        guard let first = parts.first else { return string }
        let rest = parts.dropFirst().map { $0.isEmpty ? "" : $0.prefix(1).uppercased() + $0.dropFirst() }
        return ([String(first)] + rest).joined()
    }

    /// `"helloWorld"` → `"hello_world"`.
    public static func camelToSnake(_ string: String) -> String {
        var result = ""
        for char in string {
            if char.isUppercase {
                result += "_" + char.lowercased()
            } else {
                result.append(char)
            }
        }
        return result
    }
}
