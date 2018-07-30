//
//  Data+HexString.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/30.
//  Copyright © 2018年 iblue. All rights reserved.
//

import Foundation

extension Data {
	var jm_hexDescription: String {
		return self.map { String(format: "%02hhx", $0) }.joined()
	}
	
	func jm_toUnsafePointerUInt8() -> UnsafePointer<UInt8> {
		return self.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
			return bytes
		}
	}
	
	mutating func jm_toUnsafeMutablePointerUInt8() -> UnsafeMutablePointer<UInt8> {
		return self.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
			return bytes
		}
	}
}
