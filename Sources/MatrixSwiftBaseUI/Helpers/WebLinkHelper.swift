//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-01-09.
//
import SwiftUI
import Foundation

final public class WebLinkHelper {
    // in views you can use openurl environment variable
    //    @Environment(\.openURL) var openURL
    
    #if os(iOS)
    public static func openWebLink(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    #endif
    
    // Open the iOS system settings for the app
    #if os(iOS)
    public static func openAppSystemSettings() {
        WebLinkHelper.openWebLink(UIApplication.openSettingsURLString)
    }
    #endif
}
