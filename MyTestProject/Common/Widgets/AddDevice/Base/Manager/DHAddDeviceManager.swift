//
//  DHAddDeviceManager.swift
//  LeChangeOverseas
//
//  Created by iblue on 2018/6/7.
//  Copyright © 2018年 Zhejiang bingo Technology Co.,Ltd. All rights reserved.
//	设备添加管理类，单例

import Foundation

@objc public enum DHNetConfigMode: Int {
	case wifi
	case wired
	case softAP
	case simCard
}

@objc public class DHAddDeviceManager: NSObject {
	
	@objc public static let sharedInstance = DHAddDeviceManager()
	
	@objc public var deviceId: String = ""
	
	@objc public var deviceModel: String = ""
	
	@objc public var deviceQRCodeModel: String = ""
	
	/// 配网模式
	@objc public var netConfigMode: DHNetConfigMode = .wired
	
	/// 设备初始化的密码
	@objc public var initialPassword: String = ""
	
	@objc public var wifiSSID: String? = ""
	
	@objc public var wifiPassword: String? = ""
	
	public override init() {
		super.init()
	}
	
	/// 判断当前的添加的设备，是否已经在局域网搜索到
	@objc public func isDeviceFindInLocalNetwork() -> Bool {
		return true
	}
}
