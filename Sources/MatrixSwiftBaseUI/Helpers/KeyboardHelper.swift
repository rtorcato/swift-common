//
//  KeyboardHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-12-12.
//

import SwiftUI

public struct KeyboardHelper {
    // static let shared = KeyboardHelper() // Singleton
}

#if os(iOS)
extension KeyboardHelper {
    public static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
