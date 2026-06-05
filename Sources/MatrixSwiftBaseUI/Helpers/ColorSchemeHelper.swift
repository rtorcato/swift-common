//
//  ColorSchemeHelper.swift
//  
//
//  Created by Richard Torcato on 2022-12-22.
//

import Foundation
import SwiftUI

public final class ColorSchemeHelper {
    @Environment(\.colorScheme) var colorScheme
    
    //  static let instance = ColorSchemeHelper() // Singleton
    
    func getColorScheme() -> ColorScheme {
        return colorScheme
    }
    
}
