//
//  SystemThemeManager.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-09-30.
//

import SwiftUI
import MatrixSwiftBaseCore

public final class SystemThemeManager: ObservableObject {
    @AppStorage("appSystemTheme") public var appSystemTheme: String = SystemThemes.unspecified.rawValue
//    @Published public var isUsingSystemSettings:Bool = false
//    @Published public var isUsingDarkMode:Bool = false
    
    public init() { }
    
    public func isSystemDefault() -> Bool {
        return appSystemTheme == SystemThemes.unspecified.rawValue
    }
    public func isDarkMode() -> Bool {
        return appSystemTheme == SystemThemes.dark.rawValue
    }
    
    public func getColorScheme() -> ColorScheme? {
        switch appSystemTheme {
        case "dark":
            return .dark
        case "light":
            return .light
        default:
            return nil
        }
    }
    
    public func setTheme(theme: SystemThemes) {
        appSystemTheme = theme.rawValue
//        isUsingSystemSettings = isSystemDefault()
//        isUsingDarkMode = isDarkMode()
    }
}
