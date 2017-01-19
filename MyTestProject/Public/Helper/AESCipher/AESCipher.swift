//
//  AESCipher.swift
//  MyTestProject
//
//  Created by 江斌 on 17/1/19.
//  Copyright © 2017年 iblue. All rights reserved.
//

import UIKit

fileprivate let kKeySize = kCCKeySizeAES128
class AESCipher: NSObject {

    /// 使用key对字符串进行加密
    ///
    /// - Parameters:
    ///   - content: 内容
    ///   - key: 密钥
    /// - Returns: String
    class func encrypt(content: String, withKey key: String) -> String {
        let contentData = content.data(using: .utf8)
        let keyData = key.data(using: .utf8)
        if contentData == nil ||  keyData == nil {
            return ""
        }
        
        let contentBytes = contentData!.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        
        let keyBytes = keyData!.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        
        let dataLength = contentData!.count
        let encryptSize = dataLength + kCCBlockSizeAES128
        var bufferData = Data(count: encryptSize)
        let bufferPointer = bufferData.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        }
        
        var bytesEncrypted = Int(0)
        // Perform operation
        let cryptStatus = CCCrypt(
            CCOperation(kCCEncrypt),            // Operation
            CCAlgorithm(kCCAlgorithmAES),       // Algorithm
            CCOptions(kCCOptionPKCS7Padding),   // Options
            keyBytes,                       // key data
            kKeySize,                       // key length
            nil,                            // IV buffer
            contentBytes,                       // input data
            dataLength,                     // input length
            bufferPointer,                  // output buffer
            encryptSize,                    // output buffer length
            &bytesEncrypted)                // output bytes decrypted real length
        
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            let data = Data(bytes: bufferPointer, count: bytesEncrypted)
            return data.base64EncodedString(options: .endLineWithLineFeed)
        }
        
        return ""
    }
}
