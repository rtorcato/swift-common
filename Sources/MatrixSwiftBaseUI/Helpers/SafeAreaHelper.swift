//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-01-03.
//

import SwiftUI

#if os(iOS)
public struct SafeAreaHelper {
    
    /// Gets the safe area of for the top of the application
    /// - Returns: returns CGFloat with top
    public static func getSafeAreaTop() -> CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return (keyWindow?.safeAreaInsets.top)!
    }
}
#endif
