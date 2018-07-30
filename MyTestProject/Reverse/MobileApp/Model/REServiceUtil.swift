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
	
	private let baseUrl = "https://app.dahuatech.com/GetAndroidDataService.svc/"
	
	func post(funtion: String, encodeParams: String, success: ((_ result: String)->())? = nil, failure: ((_ error: Error)->())? = nil) {
	
		let url = completeUrl(function: funtion)
		let parameters = ["jsonData": encodeParams]
		
		let headers = [
			"Accept": "application/json",
			"Content-Type": "application/json"
		]
		
		Alamofire.request(url, method: .post, parameters: parameters, headers: headers).responseData { (responseData) in
			debugPrint(responseData)
		}
	}
	
	private func completeUrl(function: String) -> String {
		return baseUrl + function
	}
}
