//
//  WebViewModel.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-03.
//

import Foundation

public class WebViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var shouldGoBack: Bool = false
    @Published var title: String = ""
    
    var url: String
    
    init(url: String) {
        self.url = url
    }
}
