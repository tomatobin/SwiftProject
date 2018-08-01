//
//  String+Encryption.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/30.
//  Copyright © 2018年 iblue. All rights reserved.
//

import Foundation

extension String {
	
	func jm_urlEncode() -> String {
		let characterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]")
		let encode = self.addingPercentEncoding(withAllowedCharacters: characterSet)
		return encode ?? self
	}
	
	func jm_encryptUseDes(key: String, iv: String?) -> String? {
		var cipherText: String?
		let encode = self.jm_urlEncode()
		
		//【*】输入
		let data = encode.data(using: .utf8)!
		let dataBytes = data.jm_toUnsafePointerUInt8()
		
		//【*】输出
		let bufferLength = data.count + kCCKeySizeDES
		var bufferData = Data(count: bufferLength)
		let buffer = bufferData.jm_toUnsafeMutablePointerUInt8()
		
		let keyBytes = key.data(using: .utf8)!.jm_toUnsafePointerUInt8()
		let ivBytes = iv?.data(using: .utf8)?.jm_toUnsafePointerUInt8()
		
		var bytesDecrypted: Int = 0
		let cryptStatus = CCCrypt( CCOperation(kCCEncrypt),
								   CCAlgorithm(kCCAlgorithmDES),
								   CCOptions(kCCOptionPKCS7Padding),
								   keyBytes,
								   key.count,
								   ivBytes,
								   dataBytes,
								   data.count,
								   buffer,
								   bufferLength,
								   &bytesDecrypted
		)
		
		if Int32(cryptStatus) == Int32(kCCSuccess) {
			let outputData = Data(bytes: buffer, count: bytesDecrypted)
			cipherText = outputData.jm_hexDescription
			
		} else {
			print("Error in crypto operation: \(cryptStatus)")
		}
		
		//print("🍎🍎🍎\(#function):: cipherText: \(cipherText ?? "")")
		return cipherText
	}
}
