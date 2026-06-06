//
//  RequestBody.swift
//  MatrixSwiftBaseCore
//
//  Created by Richard Torcato on 2026-06-06.
//

import Foundation

/// Describes the body of an HTTP request.
public enum RequestBody {

    /// No body.
    case empty

    /// Raw `Data` with an optional `Content-Type`.
    case data(Data, contentType: String? = nil)

    /// JSON payload encoded via the client's `JSONEncoder`.
    case json(any Encodable)

    /// `application/x-www-form-urlencoded` payload.
    case form([URLQueryItem])

    /// Encodes the body and returns the bytes plus a content type to apply.
    /// Returns `nil` for `.empty`.
    public func encode(using encoder: JSONEncoder) throws -> (data: Data, contentType: String)? {
        switch self {
        case .empty:
            return nil
        case .data(let data, let contentType):
            return (data, contentType ?? "application/octet-stream")
        case .json(let value):
            do {
                let data = try encoder.encode(AnyEncodable(value))
                return (data, "application/json")
            } catch {
                throw NetworkError.encoding(error)
            }
        case .form(let items):
            var components = URLComponents()
            components.queryItems = items
            let encoded = components.percentEncodedQuery ?? ""
            let data = Data(encoded.utf8)
            return (data, "application/x-www-form-urlencoded")
        }
    }
}

/// Type-erasing wrapper so `any Encodable` round-trips through `JSONEncoder.encode`,
/// which is generic over a concrete `Encodable` type.
private struct AnyEncodable: Encodable {
    private let encodeFn: (Encoder) throws -> Void

    init(_ wrapped: any Encodable) {
        self.encodeFn = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFn(encoder)
    }
}
