//
//  WebImageHelper.swift
//  MatrixSwiftBaseUI
//
//  Created by Richard Torcato on 2022-11-15.
//

import SwiftUI
import MatrixSwiftBaseCore

final class WebImageHelper {

    static let instance = WebImageHelper()

    init() { }

    @MainActor static func fetchImage(_ urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL(urlString)
        }
        let data = try await APIClient.fetchData(from: url)
        guard let image = UIImage(data: data) else {
            throw NetworkError.decoding(URLError(.cannotDecodeRawData))
        }
        return image
    }

    static func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode) else {
            return nil
        }
        return image
    }

    func fetchImage(_ imageUrl: String, completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            completionHandler(nil, NetworkError.invalidURL(imageUrl))
            return
        }
        Task {
            do {
                let data = try await APIClient.fetchData(from: url)
                completionHandler(UIImage(data: data), nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }

    func fetchImageWithAsync(_ imageUrl: String) async throws -> UIImage? {
        guard let url = URL(string: imageUrl) else {
            throw NetworkError.invalidURL(imageUrl)
        }
        let data = try await APIClient.fetchData(from: url)
        return UIImage(data: data)
    }
}
