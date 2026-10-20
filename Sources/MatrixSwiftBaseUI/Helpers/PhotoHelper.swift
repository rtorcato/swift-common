//
//  PhotoHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-20.
//

#if canImport(Photos)
import SwiftUI
import Photos

final class PhotoHelper: Sendable {
    
    static let instance = PhotoHelper() // Singleton
    
    // do not check on startup
    static func checkPhotoAccess() -> String {
        // Check the app's authorization status (either read/write or add-only access).
        let readWriteStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        //    print(readWriteStatus.rawValue)\
        var value = ""
        switch readWriteStatus {
        case .notDetermined:
            // The user hasn't determined this app's access.
            value = "The user hasn't determined this app's access."
        case .restricted:
            // The system restricted this app's access.
            value = "The system restricted this app's access."
        case .denied:
            // The user explicitly denied this app's access.
            value = "The user explicitly denied this app's access."
        case .authorized:
            // The user authorized this app to access Photos data.
            value = "The user authorized this app to access Photos data."
        case .limited:
            // The user authorized this app for limited Photos access.
            value = "The user authorized this app for limited Photos access."
        @unknown default:
            fatalError()
        }
        return value
    }
    
    /// Asks for read-write access and returns a description of the user's answer.
    static func requestPhotoAccess() async -> String {
        // Request read-write access to the user's photo library.
        switch await PHPhotoLibrary.requestAuthorization(for: .readWrite) {
        case .notDetermined:
            // The user hasn't determined this app's access.
            return "The user hasn't determined this app's access."
        case .restricted:
            // The system restricted this app's access.
            return "The system restricted this app's access."
        case .denied:
            // The user explicitly denied this app's access.
            return "The user explicitly denied this app's access."
        case .authorized:
            // The user authorized this app to access Photos data.
            return "The user authorized this app to access Photos data."
        case .limited:
            // The user authorized this app for limited Photos access.
            return "The user authorized this app for limited Photos access."
        @unknown default:
            fatalError()
        }
    }
}
#endif
