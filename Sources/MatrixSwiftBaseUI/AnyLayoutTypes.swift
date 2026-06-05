//
//  AnyLayoutType.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-28.
//

import SwiftUI

enum AnyLayoutTypes: Int, CaseIterable {
    case zStack, hStack, vStack // , altStack
    
    var index: Int {
        AnyLayoutTypes.allCases.firstIndex(where: {$0 == self})!
    }
    
    var layout: any Layout {
        switch self {
        case .zStack:
            return ZStackLayout()
        case .hStack:
            return HStackLayout(alignment: .top, spacing: 0)
        case .vStack:
            return VStackLayout(alignment: .trailing)
//        case .altStack:
//            return AlternateStackLayout()
        }
    }
}

// struct ConditionalLayoutExample2: View {
//    @Environment(\.horizontalSizeClass) private var size
//    
//    var body: some View {
//        let layout = (size == .regular) ?
//        AnyLayout(HStackLayout()) :
//        AnyLayout(VStackLayout())
//        
//        layout {
//            View1()
//            View2()
//        }
//        .animation(.default, value: size)
//    }
// }
