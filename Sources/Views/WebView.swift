//
//  WebView.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-09-30.
//

#if os(iOS)
import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {

    let request: URLRequest
    @Binding var isLoading: Bool
    @Binding var error: Error?
    
    public init(request: URLRequest, isLoading: Binding<Bool>, error: Binding<Error?>) {
        self.request = request
        self._isLoading = isLoading
        self._error = error
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    public func makeUIView(context: Context) -> WKWebView {
       let view = WKWebView()
       // isLoading = true
        view.load(request)
        view.navigationDelegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        
        public var webView: WebView
        
        public init(_ webView: WebView) {
            self.webView = webView
        }
        
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.webView.isLoading = true
            self.webView.error = nil
        }
        
        public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            self.webView.error = error
            self.webView.isLoading = false
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.webView.isLoading = false
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(request: URLRequest(url: URL(string: "https://www.apple.com")!), isLoading: .constant(false), error: .constant(nil))
    }
}
#endif
