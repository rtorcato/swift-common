//
//  NetworkError.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
    case invalidResponse
    case badUrl
    case decodingError
    case badRequest
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        case .invalidResponse:
            return NSLocalizedString("Invalid Response", comment: "Invalid Response error")
        case .badUrl:
            return NSLocalizedString("Bad Url", comment: "Bad Url")
        case .decodingError:
            return NSLocalizedString("Decoding error", comment: "Decoding error")
        case .badRequest:
            return NSLocalizedString("Bad request", comment: "Bad request error")
        }
    }
}
