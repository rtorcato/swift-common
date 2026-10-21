//
//  ResizableLottieView.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-14.
//

// import SwiftUI
//
// import Lottie
//
// struct ResizableLottieView: UIViewRepresentable {
//    var fileName: String
//    // MARK: Callback When Animation Finishes
//    var onFinish: (LottieAnimationView)->()
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        view.backgroundColor = .clear
//        setupView(for: view)
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//
//    }
//
//    func setupView(for to: UIView){
//        // MARK: Setting Up Lottie View
//        let animationView = LottieAnimationView(name: fileName,bundle: .main)
//        animationView.backgroundColor = .clear
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//
//        // MARK: For Optimized Memory
//        animationView.shouldRasterizeWhenIdle = true
//
//        let constraints = [
//            animationView.widthAnchor.constraint(equalTo: to.widthAnchor),
//            animationView.heightAnchor.constraint(equalTo: to.heightAnchor),
//        ]
//
//        to.addSubview(animationView)
//        to.addConstraints(constraints)
//
//        animationView.play{_ in
//            onFinish(animationView)
//        }
//    }
// }
