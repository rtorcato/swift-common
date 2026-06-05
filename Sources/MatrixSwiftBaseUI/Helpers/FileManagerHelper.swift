//
//  FileManagerHelper.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-04.
//

import Foundation
import SwiftUI

public final class FileManagerHelper {
    
    public static let shared = FileManagerHelper() // Singleton
    
    public static func getTempDirectory() -> URL {
        return FileManager.default.temporaryDirectory
    }
    
    public static func docExist(named docName: String) -> Bool {
        FileManager.default.fileExists(atPath: FileManagerHelper.getDocumentsDirectory().appendingPathComponent(docName).path)
    }
    public static func getApplicationSupportDirectory() -> URL {
        // find all possible application support directories for this user
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    public static func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    public static func listDocumentsDirectory() {
        let fm = FileManager.default
        let path = FileManagerHelper.getDocumentsDirectory()
        print(path.absoluteString)
        do {
            let items = try fm.contentsOfDirectory(atPath: path.absoluteString)

            for item in items {
                print("Found Docs \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    public static func getBundleDirectory() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!

        do {
            let items = try fm.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    public func saveDocument(contents: String, docName: String, completion: (Result<Bool, FileManagerError>) -> Void) {
        let url = Self.getDocumentsDirectory().appendingPathComponent(docName)
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
            completion(.success(true))
        } catch {
            completion(.failure(.saveError))
        }
    }
    
    public func readDocument(docName: String, completion: (Result<Data, FileManagerError>) -> Void) {
        let url = Self.getDocumentsDirectory().appendingPathComponent(docName)
        do {
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch {
            completion(.failure(.readError))
        }
    }
}

public enum FileManagerError: Error, LocalizedError {
    case saveError
    case readError
    case decodingError
    case encodingError
    
    public var errorDescription: String? {
        switch self {
        case .saveError:
            return NSLocalizedString("Could not save File, please reinstall the app.", comment: "")
        case .readError:
            return NSLocalizedString("Could not load ToDos, please reinstall the app.", comment: "")
        case .decodingError:
            return NSLocalizedString("There was a problem loading your ToDos, please create a new ToDo to start over.", comment: "")
        case .encodingError:
            return NSLocalizedString("Could not save ToDos, please reinstall the app.", comment: "")
        }
    }
}

// public struct FileManagerErrorType: Identifiable {
//    public let id = UUID()
//    public let error: FileManagerError
//    public init(){
//        self.id = UUID()
//
//    }
// }
