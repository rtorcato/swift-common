//
//  NetworkHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-25.
//

import Foundation
import Combine

class NetworkHelper {
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
}

extension NetworkHelper {
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unknown error occurred"
            }
        }
    }
}

// example from networkexample2020 swiftbits
extension NetworkHelper {
    struct PhotoLoadingError: Error {
        
    }
    final class RemoteObject<A>: ObservableObject {
        @Published var result: Result<A, Error>?
        var value: A? { try? result?.get() }
        let url: URL
        let transform: (Data) -> A?
        
        init(url: URL, transform: @escaping (Data) -> A?) {
            self.url = url
            self.transform = transform
        }
        
        func load() {
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                DispatchQueue.main.async {
                    if let d = data, let v = self.transform(d) {
                        self.result = .success(v)
                    } else {
                        self.result = .failure(PhotoLoadingError())
                    }
                }
            }.resume()
        }
    }
}
