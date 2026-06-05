//
//  PhotoHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-20.
//

#if canImport(Photos)
import SwiftUI
import Photos

final class PhotoHelper {
    
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
    
    static func requestPhotoAccess() -> String {
        // Request read-write access to the user's photo library.
        var value = ""
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
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
        }
        return value
    }
}
#endif
