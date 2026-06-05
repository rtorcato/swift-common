//
//  File.swift
//  
//
//  Created by Richard Torcato on 2022-12-30.
//

import Foundation
// import UIKit

// check LocalizedStringKey instead of string for localization!
public enum SystemThemes: String, CaseIterable, Equatable, Identifiable {
    case unspecified
    case dark
    case light
    
    public var id: String { UUID().uuidString }
}
