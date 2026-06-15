import Foundation

public enum BundleHelper {
    public static func loadJson<T: Decodable>(
        _ filename: String,
        bundle: Bundle = .main,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil
    ) -> T {
        guard let file = bundle.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in bundle.")
        }

        let data: Data
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from bundle:\n\(error)")
        }

        let decoder = JSONDecoder()
        if let dateDecodingStrategy {
            decoder.dateDecodingStrategy = dateDecodingStrategy
        }
        if let keyDecodingStrategy {
            decoder.keyDecodingStrategy = keyDecodingStrategy
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}
