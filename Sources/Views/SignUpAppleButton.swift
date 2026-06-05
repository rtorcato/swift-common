//
//  SignUpAppleButton.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-09-30.
//

#if os(iOS)
import SwiftUI
import AuthenticationServices

struct SignUpAppleButton: UIViewRepresentable {
  
    @Binding var credentials: ASAuthorizationCredential?
    @Binding var error: ASAuthorizationError?
    @Binding var isProcessing: Bool
  
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .black)
        
        // change style from default to sign up
        
        button.addTarget(context.coordinator, action: #selector(Coordinator.handleAuthoRequest), for: .touchUpInside)
        
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
      
        var parent: SignUpAppleButton
        
        init(_ signAppleButton: SignUpAppleButton) {
            self.parent = signAppleButton
        }
        
        @objc func handleAuthoRequest() {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.email, .fullName]
        
            let authController = ASAuthorizationController(authorizationRequests: [request])
            authController.delegate = self
            authController.presentationContextProvider = self
            
            parent.isProcessing = true
            authController.performRequests()
            
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
          
            parent.isProcessing = false
            
            switch authorization.credential {
            case let appleIDCredentials  as ASAuthorizationAppleIDCredential:
                parent.credentials = appleIDCredentials
                
            case _ as ASPasswordCredential:
                print("got password credential")
            default:
                break
            }
            
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            
             parent.isProcessing = false
            if let new = error as? ASAuthorizationError {
                parent.error = new
            }
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           
            let windowScene =  UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            return window!
            //            let vc = UIApplication.shared.windows.last?.rootViewController
            //            let vc = UIApplication.shared.currentUIWindow()?.rootViewController
            //            return (vc?.view.window)!
        }
    }
}

struct SignAppleButton_Previews: PreviewProvider {
    static var previews: some View {
        SignUpAppleButton(credentials: .constant(nil), error: .constant(nil), isProcessing: .constant(false))
        .frame(width: 200, height: 60)
    }
}

#endif
