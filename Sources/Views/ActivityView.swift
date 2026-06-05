//
//  ActivityView.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-09-30.
//
// #if os(macOS)
// import SwiftUI
// import UIKit
//
// struct ActivityIndicator: UIViewRepresentable {
//
//    let isAnimating: Bool
//
//    func makeUIView(context: Context) -> UIActivityIndicatorView {
//        let indicator = UIActivityIndicatorView()
//        indicator.color = UIColor.gray
//        indicator.style = .large
//        return indicator
//    }
//
//    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
//        if isAnimating {
//            uiView.startAnimating()
//        }else {
//            uiView.stopAnimating()
//        }
//    }
// }
//
// struct ActivityIndicator_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityIndicator(isAnimating: true)
//    }
// }
// #endif
