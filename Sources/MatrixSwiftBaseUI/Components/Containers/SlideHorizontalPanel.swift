//
//  SlideHorizontalPanel.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-02.
//

import SwiftUI

public struct SlideVerticalPanel<PanelContent: View, Content: View>: View {
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
    var panelContent: PanelContent
    var content: Content
    
    // for future drag gesture use
    //    @State var width = UIScreen.main.bounds.width - 90
    //    // to hide view
    //    @State var x = -UIScreen.main.bounds.width + 90
    
    init(isOpen: Binding<Bool>, @ViewBuilder panelContent: @escaping () -> PanelContent, @ViewBuilder content: @escaping () -> Content) {
        self._isOpen = isOpen
        self.panelContent = panelContent()
        self.content = content()
    }
    
    private func toggleShow() {
        withAnimation(.easeInOut) {
            self.isOpen.toggle()
        }
    }
    public var body: some View {
        ZStack(alignment: .leading) {
            // the main content of the app
            self.content
                .zIndex(0)
                .blur(radius: self.isOpen ? 6.0 : 0)
            
            // show or hide the translucent shield
            if isOpen {
                OverlayShieldView()
                    .onTapGesture {
                        self.toggleShow()
                    }
                //                Color.black
                //                    .zIndex(1)
                //                    .opacity(0.25)
                //                    .edgesIgnoringSafeArea(.all)
                //                    .background(.ultraThinMaterial)
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

struct SlideVerticalPanel_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            SlideVerticalPanel(isOpen: .constant(true), panelContent: {Text("hello")}, content: {Text("Hello")})
            //        SlideVerticalPanel(isOpen: .constant(true), panelContent: Text("hello")){
            //            Text("Main content")
            //        }
        }
    }
}
