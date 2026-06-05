//
//  ViewHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-03.
//

import Foundation
import SwiftUI

public final class ViewHelper {
    
    static let instance = ViewHelper() // Singleton
    
#if os(iOS)
   public static func getScreenRect() -> CGRect {
        return UIScreen.main.bounds
    }

    public static func getSafeArea() -> UIEdgeInsets {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return .zero}
        guard let safeArea = window.windows.first?.safeAreaInsets else {return .zero}
        return safeArea
    }
#endif
    
    //    static func safeArea()->UIEdgeInsets{
    //        let null = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //
    //        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
    //            return null
    //        }
    //
    //        guard let safeArea = screen.windows.first?.safeAreaInsets else{
    //            return null
    //        }
    //
    //        return safeArea
    //    }
    //    @Published var isMacOS = false // detecting For macOS
    // MacOS Data....
    //    static func getScreenRect() -> CGRect {
    //        #if os(iOS)
    //        return UIScreen.main.bounds
    //        #else
    //        return NSScreen.main!.visibleFrame
    //        #endif
    //    }
    //    func getScreenBounds(){
    //        return screen.screen.bounds
    //    }
    
    // MARK: Safe Area Value
    //    func safeArea()->UIEdgeInsets{
    //        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return .zero}
    //        guard let safeArea = window.windows.first?.safeAreaInsets else{return .zero}
    //
    //        return safeArea
    //    }
    
}
