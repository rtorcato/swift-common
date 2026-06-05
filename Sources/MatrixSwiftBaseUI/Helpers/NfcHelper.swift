//
//  NfcHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-10.
//

import SwiftUI
import Foundation
// import Stripe

final class NfcHelper {
    
    static let instance = NfcHelper() // Singleton
    
    init() {

    }
    
    /// Setup stripe keys
    ///
    ///
    static func setup() {
        // #warning("Please user your own Stripe Publishable key below")
        // Stripe.setDefaultPublishableKey("pk_test_xxxxxxxxxxxxxxxxxxxxxx")
        // StripeAPI.defaultPublishableKey = AppConstants.STRIPE_PUBLISHING_KEY
    }
}
