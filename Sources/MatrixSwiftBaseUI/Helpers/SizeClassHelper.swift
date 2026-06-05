//
//  File.swift
//  
//
//  Created by Richard Torcato on 2022-12-22.
//

import SwiftUI

#if os(iOS)
public struct SizeClassHelper {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    public var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    public var isPortrait: Bool {
        verticalSizeClass == .compact
    }
    
    public var isPortraitIPad: Bool {
        horizontalSizeClass == .regular
    }
    //    if UIDevice.current.userInterfaceIdiom == .pad {
    //        ...
    //    }
    //    if UIDevice.current.localizedModel == "iPhone" {
    //         print("This is an iPhone")
    //    } else if UIDevice.current.localizedModel == "iPad" {
    //         print("This is an iPad")
    //    }
}
#endif
