//
//  AppExt.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-09-30.
//

import Foundation
#if os(iOS)
    import UIKit
#endif

#if os(macOS)
    import AppKit
#endif

#if os(iOS)
extension UIApplication {
    static var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
#endif
