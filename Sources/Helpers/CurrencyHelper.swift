//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-01-26.
//

import Foundation

public final class CurrencyHelper {
    
    static let instance = CurrencyHelper()
    private init() { }
    
    /// Converts a Double into a Currency with 2 decimal places
    /// ```
    ///  Convert 1234.56 to $1234.56
    /// ```
    public static var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        // formatter.locale = .current // <- default value
        // formatter.currencyCode = "usd" // <- change currency
        // formatter.currencySymbol = "$" // <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    // Converts a Double into a Currency as a String with  2 decimal places
    // ```
    //  Convert 1234.56 to "$1234.56"
    // ```
//    func asCurrencyWith2Decimals() -> String {
//        let number = NSNumber(value: self)
//        return currencyFormatter2.string(from: number) ?? "$0.00"
//    }
    
    /// Converts a Double into a Currency with 2-6 decimal places
    /// ```
    ///  Convert 1234.56 to $1234.56
    ///  Convert 12.3456 to $12.3445
    ///  Convert 0.123456 to $0.123456
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        // formatter.locale = .current // <- default value
        // formatter.currencyCode = "usd" // <- change currency
        // formatter.currencySymbol = "$" // <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    // Converts a Double into a Currency as a String with  2-6 decimal places
    // ```
    //  Convert 1234.56 to "$1234.56"
    //  Convert 12.3456 to "$12.3445"
    //  Convert 0.123456 to "$0.123456"
    // ```
//    func asCurrencyWith6Decimals() -> String {
//        let number = NSNumber(value: self)
//        return currencyFormatter6.string(from: number) ?? "$0.00"
//    }
    
    /// Converts a Double into a string representation
    /// ```
    ///  Convert 1.2345 to "1.23"
    /// ```
    public static func asNumberString(_ val: Double) -> String {
        return String(format: "%.2f", val)
    }
    
//    /// Converts a Double into a string representation with percent symbol
//    /// ```
//    ///  Convert 1.2345 to "1.23%"
//    /// ```
//    public static func asPercentString() -> String {
//        return asNumberString() + "%"
//    }
    
}
