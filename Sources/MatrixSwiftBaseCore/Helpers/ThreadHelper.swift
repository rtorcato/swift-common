//
//  ThreadHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-12-13.
//

import Foundation

final class ThreadHelper {
    
    static let shared = ThreadHelper() // Singleton
    
//    static func closeKeyboard(){
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
    
//    func mainAsync() { [weak self] data in
//        DispatchQueue.main.async {
//            //self?.label.text = data
//        }
//    }
}

// func getData2(url: URL) async throws -> Data {
//    return try await withCheckedThrowingContinuation { continuation in
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                continuation.resume(returning: data)
//            } else if let error = error {
//                continuation.resume(throwing: error)
//            } else {
//                continuation.resume(throwing: URLError(.badURL)).resume( )
//            }
//        }
//    }
// }
