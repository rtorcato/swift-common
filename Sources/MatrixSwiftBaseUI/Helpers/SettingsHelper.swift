import SwiftUI

public enum SettingsHelper {
    public static func openAppSystemSettings() {
        #if os(iOS) || os(tvOS) || os(visionOS)
        let settingsString = UIApplication.openSettingsURLString
        if let settingsURL = URL(string: settingsString) {
            UIApplication.shared.open(settingsURL)
        }
        #endif
    }
}
