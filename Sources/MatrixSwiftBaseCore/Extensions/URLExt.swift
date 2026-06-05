//
//  URLExt.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-19.
//

import Foundation

extension URL {
    init(_ staticString: StaticString) {
        guard let url = URL(string: "\(staticString)") else {
            preconditionFailure("Invalid static URL string: \(staticString)")
        }
        self = url
    }
}
