//
//  FaceIdHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-21.
//

#if os(iOS)
import Foundation
import LocalAuthentication

final class FaceIdHelper {
            
    static let instance = FaceIdHelper() // Singleton
    
    static func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                if success {
                    Task { @MainActor in
//                        self.isUnlocked = true
                        print("Face Auth ok")
                    }
                } else {
                    // error
                    print("Face Auth error")
                }
            }
        } else {
            // no biometrics
        }
    }
}
#endif
