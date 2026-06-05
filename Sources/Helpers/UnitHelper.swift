//
//  UnitHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-19.
//

import Foundation

public struct UnitHelper {
    
    // static let shared = UnitHelper() // Singleton
    
    static func convertToFahrenheit(_ C: Int) -> Int {
        Int(round(Double(C) * 9 / 5 + 32))
    }
    static func convertToCelsius( F: Int) -> Int {
        Int(round((Double(F) - 32) * 5 / 9))
    }
}
