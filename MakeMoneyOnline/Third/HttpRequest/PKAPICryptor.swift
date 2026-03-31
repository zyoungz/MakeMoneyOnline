//
//  AES256Cryptor.swift
//  Pick记账
//
//  Created by Dev on 2023/6/8.
//

import CryptoSwift

class PKAPICryptor {
    
    static private let key: [UInt8] = Array("3W4D2aZ6YyEf0Cx5FR<1A{lSLP8oBMBB".utf8)
    static private let iv: [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    
    static func encrypt(string: String) -> String? {
        guard !string.isEmpty else {
            return nil
        }
        
        do {
            let data = Data(string.utf8)
            let aes = try AES(key: key, blockMode:CBC(iv: iv), padding: .pkcs5)
            let encrypted = try aes.encrypt(Array(data))
            let encryptedData = Data(encrypted)
            return encryptedData.base64EncodedString()
        } catch {
            return nil
        }
    }
    
    static func decrypt(string: String) -> String? {
        guard !string.isEmpty else {
            return nil
        }
        
        guard let data = Data(base64Encoded: string) else {
            return nil
        }
        
        do {
            let aes = try AES(key: key, blockMode:CBC(iv: iv), padding: .pkcs5)
            let decrypted = try aes.decrypt(Array(data))
            let decryptedData = Data(decrypted)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
