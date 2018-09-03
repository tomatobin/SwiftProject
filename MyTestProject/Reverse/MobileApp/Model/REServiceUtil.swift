//
//  REServiceUtil.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/30.
//  Copyright © 2018年 iblue. All rights reserved.
//	MobileApi

import UIKit
import Alamofire

enum REServiceFunction: String {
	case getCheckStatusData = "GetCheckStatusData"
	case uploadCheckData = "UploadCheckData"
	case getNewAmapListData = "GetNewAmapListData"
	case getAttendanceListData = "GetAttendanceListData"
	
	static func functionList() -> [String] {
		return [REServiceFunction.getCheckStatusData.rawValue,
				REServiceFunction.uploadCheckData.rawValue,
				REServiceFunction.getNewAmapListData.rawValue,
				REServiceFunction.getAttendanceListData.rawValue]
	}
}

class REServiceUtil: NSObject {
	
	static let sharedInstance = REServiceUtil()
	
	private let encryptBaseUrl = "5f9738a419e02995e79dc869bf7b05ebcd9b00649ed19d32263886da0402ea1a08c7ecdcdb321aa2d92375abada16db2417677c81e856adef7e303acee7244e38c6e0c27a0db2e33051674489c75cafeecb00a85345783ededfd38d3a996753093bec3e4467d711b94dd5f8a414a5ec97c016dc7f29844ab4cc2f6225b564ad0512284e4a6828a4806258b680b7100937b71ebdb77151c86"
	
	private let baseUrl = "https://app.dahuatech.com/GetAndroidDataService.svc/"
	
	func post(funtion: String, encodeParams: String, success: ((_ result: String)->())? = nil, failure: ((_ error: Error?)->())? = nil) {
	
		let url = completeUrl(function: funtion)
		let parameters = ["jsonData": encodeParams]
		
		let headers = [
			"Accept": "application/json",
			"Content-Type": "application/json"
		]
		
		print("🍎🍎🍎 \(#function):: url\(url), parameters:\(parameters)")
		
		let requestComplete: (HTTPURLResponse?, Result<Any>) -> Void = { response, result in
			if let response = response {
				for (field, value) in response.allHeaderFields {
					print("\(field): \(value)")
				}
			}
			
			if result.isSuccess {
				if let value = result.value as? [String: Any], let valueResult = value["Result"] {
					var jsonString: String = ""
					if valueResult is String {
						jsonString = valueResult as! String
					} else if let data = try? JSONSerialization.data(withJSONObject: valueResult, options: .prettyPrinted) {
						jsonString = String(data: data, encoding: .utf8) ?? ""
					}
					
					print("🍎🍎🍎 \(#function):: Result:\(jsonString)")
					success?(jsonString)
				}
				
			} else {
				failure?(result.error)
			}
		}
		
		//【*】默认是URLEncoding，会导致解析错误； 需要使用JSONEncoding.default
		Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseData) in
			requestComplete(responseData.response, responseData.result)
		}
	}
	
	private func completeUrl(function: String) -> String {
		return baseUrl + function
	}
}
