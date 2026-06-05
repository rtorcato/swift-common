//
//  StorekitHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-09.
//

import SwiftUI
import StoreKit

public final class StoreKitHelper {
    #if os(iOS)
    @Environment(\.requestReview) private var storeKitRequestReview
    #endif
    //    static let instance = StoreKitHelper() // Singleton
    
    public init() {
        
    }
    #if os(iOS)
    public func requestStoreReview() {
        // SKStoreReviewController.requestReview()
        DispatchQueue.main.async {
            self.storeKitRequestReview()
        }
    }
    #endif
    
    #if os(macOS)
    public func requestMacStoreReview(itunesStoreURL: String) {
        // "https://itunes.apple.com/app/id123456789?action=write-review"
        guard let writeReviewURL = URL(string: itunesStoreURL) else {
              print("Invalid itunes store URL")
              return
        }
        NSWorkspace.shared.open(writeReviewURL)
    }
    #endif
    
    //    public static func requestReview() {
    //        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
    //            DispatchQueue.main.async {
    //                requestReview()
    //            }
    //        }
    //    }
}
