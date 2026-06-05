//
//  WebViewSampleView.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-03.
//

import SwiftUI

#if os(iOS)

public struct WebViewSampleView: View {
    
    @ObservedObject var webViewModel = WebViewModel(url: "https://www.apple.com/")
    
    public var body: some View {
        NavigationView {
            ZStack {
                WebViewContainer(webViewModel: webViewModel)
                if webViewModel.isLoading {
                    //                        Spinner().frame(height: 30)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .navigationBarTitle(Text(webViewModel.title), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                webViewModel.shouldGoBack.toggle()
            }, label: {
                if webViewModel.canGoBack {
                    Image(systemName: "arrow.left")
                        .frame(width: 44, height: 44, alignment: .center)
                        .foregroundColor(.black)
                } else {
                    EmptyView()
                        .frame(width: 0, height: 0, alignment: .center)
                }
            })
            )
        }
    }
}

struct WebViewSampleView_Previews: PreviewProvider {
    static var previews: some View {
        WebViewSampleView()
    }
}
#endif
