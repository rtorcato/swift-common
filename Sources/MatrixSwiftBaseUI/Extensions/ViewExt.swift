//
//  ViewExt.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-21.
//

import SwiftUI

extension View {
    
    // MARK: Read View Size
    public func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    // MARK: View Alignment helpers
    /// - Useful for moving Views btw HStack and VStack
    public func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    public func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    // MARK: Disabling with Opacity
    public func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    // MARK: Custom Border View With Padding
    public func border(_ width: CGFloat, _ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    // MARK: Custom Fill View With Padding
    public func fillView(_ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
    
    // MARK: Corner Radius with clipshape
    #if os(iOS)
        public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
            clipShape(RoundedCorner(radius: radius, corners: corners))
        }
    #endif
    
    // MARK: Embed navigation
    public func embedInNavigationView() -> some View {
        return NavigationView { self }
    }
    
    @available(iOS 16.0, *)
    public func embedInNavigationStack() -> some View {
        return NavigationStack { self }
    }
    
    // MARK: Apply if
    @ViewBuilder public func applyIf<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        // applies a modifier based on a condition
        if condition {
            transform(self)
        } else {
            self
        }
    }
    /*
     /// example
     struct ContentView: View {
     
     private var shouldApplyBackground: Bool {
     guard #available(iOS 14, *) else {
     return true
     }
     return false
     }
     
     var body: some View {
     Text("Hello, world!")
     .padding()
     .if(shouldApplyBackground) { view in
     // We only apply this background color if shouldApplyBackground is true
     view.background(Color.red)
     }
     }
     }
     */
}

/*
 // Original article here: https://fivestars.blog/articles/swiftui-share-layout-information/
 Example:
 var body: some View {
 childView
 .readSize { newSize in
 print("The new child size is: \(newSize)")
 }
 }
 */
private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
