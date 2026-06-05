//
//  File.swift
//  
//
//  Created by Richard Torcato on 2022-12-29.
//

import SwiftUI

public final class KeychainManager {
    private var cache = [UUID: UIImage]()
    
    public static func savePassword(
        service: String,
        account: String,
        password: String
    ) throws {
        let passwordData = password.data(using: .utf8) ?? Data()
        // service, account, password, class
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: passwordData as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    static func getPassword(
        service: String,
        account: String
    ) throws -> String {
        // service, account, class, return-data, matchlimit
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        let data = (result as? Data) ?? Data()
        return String(bytes: data, encoding: .utf8) ?? ""
    }
   
}

extension KeychainManager {
    public enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
}
// MARK: Example - save
// do {
//    try KeychainManager.save(
//    service: "facebook.com",
//    account: "accountID",
//    password: "password"
// } catch {
//    print(error)
// }
// MARK: Example - get
// do {
//     let password = try KeychainManager.get( service: "facebook.com", account: "accountID")
//     print(password)
// } catch {
//    print(error)
// }
