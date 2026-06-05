//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-02-08.
//

import SwiftUI

public struct ScreenHelper {
    
    // MacOS Data....
//    #if os(iOS) && os(macOS)
//    public static var screen: CGRect{
//    #if os(iOS)
//        return UIScreen.main.bounds
//    #else
//        return NSScreen.main!.visibleFrame
//    #endif
//    }
//    #endif
   
}

#if os(iOS)
extension ScreenHelper {
    public static func getScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
}
#endif

// struct EmbedInNavigation: ViewModifier {
//    @State var screenWidth:String = ""
//    func body(content: Content) -> some View {
//        NavigationView {
//            VStack {
//                Text(screenWidth)
//                content
//            }
//             .navigationTitle("Lazy#Grids")
//        }
//        .onReceive(NotificationCenter.Publisher(center: .default, name: UIDevice.orientationDidChangeNotification)) { _ in
//            screenWidth = "Screen Width: \(String(format: "%.0f",UIScreen.main.bounds.size.width))"
//        }
//        .onAppear {
//            screenWidth = "Screen Width: \(String(format: "%.0f",UIScreen.main.bounds.size.width))"
//        }
//    }
// }
