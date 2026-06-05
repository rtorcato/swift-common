//
//  HVStack.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-03.
//

import SwiftUI
#if os(iOS)
public struct VHStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ViewBuilder var content: () -> Content
//    let content: Content

//    init(@ViewBuilder _ content: () -> Content) {
//        self.content = content()
//    }

    public var body: some View {
        if horizontalSizeClass == .compact {
            VStack(content: content)
        } else {
            HStack(content: content)
        }
//        if horizontalSizeClass == .compact {
//            VStack {
//                content()
//            }
//        } else {
//            HStack {
//                content()
//            }
//        }
    }
}
#endif
