//
//  LocalAuthenticationHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-21.
//

import SwiftUI

#if os(iOS)
import LocalAuthentication

final class LocalAuthenticationHelper {
    private(set) var context: LAContext
    private(set) var canEvaluatePolicy = false
    private(set) var biometryType: LABiometryType = .none
    
    static let shared = LocalAuthenticationHelper() // Singleton
    
    // On initialize of this class, get the biometryType
    init() {
        self.context = LAContext()
        self.biometryType = self.context.biometryType
    }
    
    static func getBioMetricStatus() -> Bool {
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
    }
    
    // canEvaluatePolicy will let us know if the user's device supports biometrics authentication
    func deviceBiometricsSupported() -> Bool {
        let canEvaluatePolicy = self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return canEvaluatePolicy
    }
    
    func getBiometryType() -> LABiometryType {
        // Getting the biometryType - in other words, if the device supports FaceID, TouchID, or doesn't support biometrics auth
        return self.context.biometryType
    }
    
    func getBiometrySymbol() -> String? {
        switch self.context.biometryType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        default:
            return nil
        }
    }
    
    static func authenticateUser(localizedReason: String = "To Unlock User") {
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { (_, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
        }
    }
    
//    func authenticateWithBiometrics() async {
//        // Resetting the LAContext so on the next login, biometrics are checked again
//        context = LAContext()
//
//        // Only evaluatePolicy if device supports biometrics auth
//        if canEvaluatePolicy {
//            let reason = "Log into your account"
//
//            do {
//                // evaluatePolicy will check if user is the device's owner, returns a boolean value that'll let us know if it successfully identified the user
//                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
//
//                // Only if it's a success, we'll set isAuthenticated to true
//                if success {
//                    DispatchQueue.main.async {
////                        self.isAuthenticated = true
////                        print("isAuthenticated", self.isAuthenticated)
//                    }
//                }
//            } catch {
//                print(error.localizedDescription)
//
//                // If we run into an error, we'll set the errorDescription, we'll show an alert and set the biometryType to none, so user can login with credentials
//                DispatchQueue.main.async {
////                    self.errorDescription = error.localizedDescription
////                    self.showAlert = true
//                    self.biometryType = .none
//                }
//            }
//        }
//    }
}
#endif
