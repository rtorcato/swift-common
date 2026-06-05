//
//  HapticsHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-21.
//

import Foundation
import SwiftUI

#if os(iOS)
public final class HapticsHelper {
    
    static let hapticsEnabledKeyName = "hapticsEnabled"
    private let feedback = UINotificationFeedbackGenerator()
    
    static let shared = HapticsHelper() // Singleton
    
    private init() {}
    
    static func triggerSimple() {
        if UserDefaults.standard.bool(forKey: Self.hapticsEnabledKeyName) {
            HapticsHelper.shared.feedback.notificationOccurred(.success)
        }
    }
    
    static func trigger(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        if UserDefaults.standard.bool(forKey: Self.hapticsEnabledKeyName) {
            HapticsHelper.shared.feedback.notificationOccurred(type)
        }
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    func haptic(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
        HapticsHelper.trigger(notification)
    }
}
#endif
