//
//  ColorHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-09-20.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

final public class ColorHelper {
    
//    public static let instance = ColorHelper() // Singleton 
    
    // get color object to be used in swiftui from UIColor
//        static func getColor (_ hex:String) -> Color {
//            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//            if (cString.hasPrefix("#")) {
//                cString.remove(at: cString.startIndex)
//            }
//
//            if ((cString.count) != 6) {
//                return Color.gray
//            }
//
//            var rgbValue:UInt64 = 0
//            Scanner(string: cString).scanHexInt64(&rgbValue)
//
//            let uiColor = UIColor(
//                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//                alpha: CGFloat(1.0))
//
//            return Color(uiColor)
//        }
    
        /*
         example: static let imageColor = ColorHelper.getColorFromRGB(r: 95, g: 99, b: 120)
         */
        public static func getColorFromRGB(r: Double, g: Double, b: Double) -> Color {
            return Color(red: r / 255, green: g / 255, blue: b / 255)
        }
    
    #if canImport(UIKit)
    public static func getRandomColor() -> UIColor {
        return UIColor(displayP3Red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1), alpha: 1.0)
    }
    #endif
}

// extension UIColor {
//    static var random: UIColor {
//        return UIColor(
//            red: .random(in: 0...1),
//            green: .random(in: 0...1),
//            blue: .random(in: 0...1),
//            alpha: 1.0
//        )
//    }
// }
