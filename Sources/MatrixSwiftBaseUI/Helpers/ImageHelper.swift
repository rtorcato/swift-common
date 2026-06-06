//
//  ImageHelper.swift
//  MatrixSwiftBaseUI
//
//  Created by Richard Torcato on 2022-10-24.
//

import Foundation
import SwiftUI
import MatrixSwiftBaseCore

final class ImageHelper {

    static let instance = ImageHelper()

    public static func getWebImage(imageURL: String) async throws -> UIImage? {
        guard let url = URL(string: imageURL) else {
            throw NetworkError.invalidURL(imageURL)
        }
        let data = try await APIClient.fetchData(from: url)
        return UIImage(data: data)
    }

    static func createThumbnail() {
        // Placeholder for future thumbnail helper.
    }
}
