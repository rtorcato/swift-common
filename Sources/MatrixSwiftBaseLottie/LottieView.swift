//
//  LottieView.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-14.
//

// import SwiftUI
// import Lottie
//
// public struct LottieViewMAC: NSViewRepresentable{
//    
//    
//    public init(lottieFile: String, loopMode: LottieLoopMode = .loop, autostart: Bool = true, contentMode: LottieContentMode = LottieContentMode.scaleAspectFit) {
//        
//        self.lottieFile = lottieFile
//        self.loopMode = loopMode
//        self.autostart = autostart
//        self.contentMode = contentMode
//    }
//    
//    
//    let lottieFile: String
//    let loopMode: LottieLoopMode
//    let autostart: Bool
//    let contentMode: LottieContentMode
//    
//    
//    let animationView = AnimationView()
//    
//    public func makeNSView(context: Context) -> some NSView {
//        let theView = NSView()
//      
//        animationView.animation = Animation.named(lottieFile)
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = loopMode
//        animationView.backgroundBehavior = .pauseAndRestore
//        
//
//        if self.autostart{
//            animationView.play()
//        }
//        
//        theView.addSubview(animationView)
//        
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        animationView.heightAnchor.constraint(equalTo: theView.heightAnchor).isActive = true
//        animationView.widthAnchor.constraint(equalTo: theView.widthAnchor).isActive = true
//        animationView.leadingAnchor.constraint(equalTo: theView.leadingAnchor).isActive = true
//        animationView.trailingAnchor.constraint(equalTo: theView.trailingAnchor).isActive = true
//        
//        animationView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        animationView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        
//        return theView
//    }
//    
//    
//    func pause(){
//        animationView.pause()
//    }
//    
//    func play(){
//        animationView.play()
//    }
//    
//    func stop(){
//        animationView.stop()
//    }
//    
//    public func updateNSView(_ nsView: NSViewType, context: Context) {
//        
//    }
// }
// 
//// struct LottieView: UIViewRepresentable {
////    let lottieFile: String
////
////    let animationView = LottieAnimationView()
////
////    func makeUIView(context: Context) -> some UIView {
////        let view = UIView(frame: .zero)
////
////        animationView.animation = Animation.named(lottieFile)
////        animationView.contentMode = .scaleAspectFit
////        //animationView.loopMode = .loop
////        //animationView.animationSpeed = 3.0
////        animationView.play()
////
////        view.addSubview(animationView)
////
////        animationView.translatesAutoresizingMaskIntoConstraints = false
////        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
////        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
////
////        return view
////    }
////
////    func updateUIView(_ uiView: UIViewType, context: Context) {
////
////    }
//// }
//
//
// struct LottieRemoteView: UIViewRepresentable {
//    let lottieFileURL: URL = URL(string: "https://assets1.lottiefiles.com/packages/lf20_kd5rzej5.json")!
//    
// 
//    let animationView = LottieAnimationView()
// 
//    func makeUIView(context: Context) -> some UIView {
//        let view = UIView(frame: .zero)
//        
//        Animation.loadedFrom(url: lottieFileURL, closure: { animation in
//         
//            animationView.animation = animation
//            animationView.contentMode = .scaleAspectFit
//            animationView.loopMode = .loop
//            animationView.animationSpeed = 5.0
//            animationView.play()
//         
//        }, animationCache: nil)
//
//        view.addSubview(animationView)
// 
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
// 
//        return view
//    }
// 
//    func updateUIView(_ uiView: UIViewType, context: Context) {
// 
//    }
// }
//
//// example: LottieView(lottieFile: "contact-us").frame(width: 300, height: 300)
//// example LottieRemoteView(lottieFileURL:URL(string: "https://assets1.lottiefiles.com/packages/lf20_kd5rzej5.json")!).frame(width:300, height:300)
