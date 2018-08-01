//
//  REServiceModel.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/30.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class REServiceModel: NSObject {

	/// 基本请求参数：模块id
	var FModuleId: String = "3093"
	
	/// 基本请求参数：手机类型 IOS/Android
	var FMobileType: String = "IOS"
	
	/// 基本请求参数：手机系统版本号
	var FOSVersion: String = "11.4.1"
	
	/// 基本请求参数：App版本号
	var FAppVersion: String = "v4.0.7.Basics (56)"
	
	/// 基本请求参数：工号
	var FItemNumber: String = ""
	
	func jsonParams() -> String {
		let dic = dicParams()
		var json: String?
		if let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) {
			json = String(data: data, encoding: .utf8)
		}
		
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::\(#function):\(json ?? "")")
		return json ?? ""
	}
	
	private func dicParams() -> [String: Any] {
		var dic = [String: Any]()
		
		if FOSVersion.count > 0 {
			dic["FOSVersion"] = FOSVersion
		}
		
		if FMobileType.count > 0 {
			dic["FMobileType"] = FMobileType
		}
		
		if FAppVersion.count > 0 {
			dic["FAppVersion"] = FAppVersion
		}
		
		if FModuleId.count > 0 {
			dic["FModuleId"] = FModuleId
		}
		
		if FItemNumber.count > 0 {
			dic["FItemNumber"] = FItemNumber
		}
		
		return dic
	}
}
