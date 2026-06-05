//
//  StickyHeader.swift
//  DropWallet
//
//  Created by Richard Torcato on 2023-02-23.
//

import SwiftUI

public struct StickyHeader<Content: View>: View {

    var minHeight: CGFloat
    var content: Content
    
    public init(minHeight: CGFloat = 200, @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geo in
            if geo.frame(in: .global).minY <= 0 {
                content
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            } else {
                content
                    .offset(y: -geo.frame(in: .global).minY)
                    .frame(width: geo.size.width, height: geo.size.height + geo.frame(in: .global).minY)
            }
        }.frame(minHeight: minHeight)
    }
}

struct StickyHeaderExample: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
               StickyHeader {
                   ZStack {
                       Color(red: 35/255, green: 45/255, blue: 50/255)
                       VStack {
                           Text("Joshua Tree")
                               .font(.title)
                               .fontWeight(.bold)
                               .foregroundColor(.white)
                           Text("California")
                               .font(.title2)
                               .fontWeight(.semibold)
                               .foregroundColor(.white)
                       }
                   }
               }
               
               // Scroll View Content Here
               // ...
           }
    }
}

struct StickyHeaderExample_Previews: PreviewProvider {
    static var previews: some View {
        StickyHeaderExample()
    }
}
