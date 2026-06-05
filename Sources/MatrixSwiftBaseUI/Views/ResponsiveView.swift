//
//  ResponsiveView.swift
//  ResponsiveUI (iOS)
//
//  Created by Balaji on 04/03/22.
//

import SwiftUI

#if os(iOS)

// MARK: Custom View which will return the properties of the view
public struct ResponsiveView<Content: View>: View {
    var content: ((ResponsiveViewProperties) -> Content)
    // Returning properties
    
//    public init(){
////        self.content = ResponsiveViewProperties(isLandscape: isLandscape, isiPad: isiPad, isSplit: isSplit, size: size)
//    }
    
    public var body: some View {
        GeometryReader {proxy in
            let size = proxy.size
            let isLandscape = (size.width > size.height)
            let isiPad = UIDevice.current.userInterfaceIdiom == .pad
            let isSplit = AppHelper.isUsingSplitView()
            
            content(ResponsiveViewProperties(isLandscape: isLandscape, isiPad: isiPad, isSplit: isSplit, size: size))
                .frame(width: size.width, height: size.height, alignment: .center)
                .onAppear {
                    // Updating fraction on intial
                    updateFraction(fraction: isLandscape && !isSplit ? 0.3 : 0.5)
                }
                .onChange(of: isSplit, perform: { _ in
                    updateFraction(fraction: isLandscape && !isSplit ? 0.3 : 0.5)
                })
                .onChange(of: isLandscape) { newValue in
                    updateFraction(fraction: newValue && !isSplit ? 0.3 : 0.5)
                }
        }
    }
    
    func updateFraction(fraction: Double) {
        NotificationCenter.default.post(name: NSNotification.Name("UPDATEFRACTION"), object: nil, userInfo: [ "fraction": fraction])
    }
}
// extension ResponsiveView {
   public struct ResponsiveViewProperties {
        public var isLandscape: Bool
        public var isiPad: Bool
        public var isSplit: Bool
        public var size: CGSize
    }
// }

#endif
