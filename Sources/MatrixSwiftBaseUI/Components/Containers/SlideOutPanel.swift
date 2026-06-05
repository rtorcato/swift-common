//
//  SlideOutPanel.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-01.
//

import SwiftUI

// HStack<Content> : View where Content : View {
public struct SlideOutPanel<Content, MainContent>: View where Content: View, MainContent: View {
    enum SlideOutDirection {
        case right
        case left
    }
    enum SlideOutPosition {
        case right
        case left
    }
    @Binding var isOpen: Bool
    var slideOutDirection: SlideOutDirection = .right
    var slideOutPosition: SlideOutPosition = .left
    var panelWidth: Int = 300
    // var @Binding var isDark: Bool
    //    private let panelContent : PanelContent
    //    private let content : Content
    let panelContent: Content
    let mainContent: MainContent
    
    // for future drag gesture use
    //    @State var width = UIScreen.main.bounds.width - 90
    //    // to hide view
    //    @State var x = -UIScreen.main.bounds.width + 90
    
    public init(isOpen: Binding<Bool>, @ViewBuilder panelContent: @escaping () -> Content, @ViewBuilder mainContent: @escaping () -> MainContent) {
        self._isOpen = isOpen
        self.panelContent = panelContent()
        self.mainContent = mainContent()
    }
    
    private func toggleShow() {
        withAnimation(.easeInOut) {
            self.isOpen.toggle()
        }
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            // the main content of the app
            self.mainContent
                .zIndex(0)
                .blur(radius: self.isOpen ? 6.0 : 0)
            
            // show or hide the translucent shield
            if isOpen {
                OverlayShieldView()
                    .onTapGesture {
                        self.toggleShow()
                    }
            }
            // show or hide the sidebar itself
            if isOpen {
                self.panelContent
                    .zIndex(2)
                    .frame(width: CGFloat(self.panelWidth))
                    .frame(maxHeight: .infinity)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .leading))
                    )
                // hiding the View when back is pressed
                //                withAnimation {
                //                    x = -width
                //                }
                // adding gesture or drag feature
                //                    .offset(x: x)
                //                .gesture(
                //                    DragGesture()
                //                        .onChanged({ value in
                //                            withAnimation {
                //                                if value.translation.width > 0 {
                //                                    // disabling over drag
                //                                    if x < 0 {
                //                                        x = -width + value.translation.width
                //                                    }
                //                                } else {
                //                                    x = value.translation.width
                //                                }
                //                            }
                //                        })
                //                        .onEnded({ value in
                //                            withAnimation {
                //                                // checking if half the value of menu is dragged means setting x to 0
                //                                if -x < width / 2 {
                //                                    x = 0
                //                                } else {
                //                                    x = -width
                //                                }
                //                            }
                //                        })
                //                )
            }
        }
    }
}

// extension View {
//    public func slideOutPanel(isOpen: Binding<Bool>, @ViewBuilder panelContent: () -> any View) -> any View {
//        return VStack{
//            panelContent()
//            Text("hello")
//            self
//        }
////        return HStack{
////            SlideOutPanel(isOpen: isOpen, panelContent: panelContent, content: {Text("hello")})
////        }
////        return SlideOutPanel<View, Content:any View>(isOpen: isOpen, panelContent: panelContent, content: () -> {Text("hello")})
//    }
// }
