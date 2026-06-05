//
//  StringHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-17.
//

import SwiftUI

public final class StringHelper {
    
//    public static let shared = StringHelper() // Singleton
    
    public init() { }
    
    public static func toPhoneNumber(value: String) -> String {
        return value.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    public static func removeHtmlChars(value: String) -> String {
        return value.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    public static func matchesRegex(regularExpression: String, inputText: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: regularExpression) else {
            return false
        }
        return regex.firstMatch(in: inputText, range: NSRange(inputText.startIndex..., in: inputText)) != nil
    }
    
    public static func isStringNumeric(_ val: String) -> Bool {
        return Double(val) != nil
    }
}
