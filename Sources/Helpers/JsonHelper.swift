//
//  SwiftUIView.swift
//  
//
//  Created by Richard Torcato on 2023-03-10.
//

import Foundation

public struct JsonHelper {
    
    public static func loadJson<T: Decodable>(
        _ filename: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil) -> T {
        let data: Data
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)  else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            if let dateDecodingStrategy = dateDecodingStrategy {
                decoder.dateDecodingStrategy = dateDecodingStrategy
            }
            if let keyDecodingStrategy = keyDecodingStrategy {
                decoder.keyDecodingStrategy = keyDecodingStrategy
            }
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
