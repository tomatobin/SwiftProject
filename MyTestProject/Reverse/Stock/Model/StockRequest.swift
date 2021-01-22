//
//  StockRequest.swift
//  MyTestProject
//
//  Created by iblue on 2020/10/16.
//  Copyright © 2020 iblue. All rights reserved.
//

import UIKit
import Alamofire

class StockRequest: NSObject {
    
    let urlPrefix = "https://hq.sinajs.cn/list="
    
    var showColor: Bool = false
    
    var showLog: Bool = true

    var sessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    func request(stocks: [String], completion:((_ stockList: [StockInfo])->())? = nil) {
        
        let requestComplete: (HTTPURLResponse?, Result<Data>) -> Void = { response, result in
            if let response = response {
                for (field, value) in response.allHeaderFields {
                    print("\(field): \(value)")
                }
            }
            
            var stockList: [StockInfo] = [StockInfo]()
            
            if result.isSuccess {
                //SWIFT GBK编码转换
                let cfEncoding = CFStringEncodings.GB_18030_2000
                let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
                
                if let value = result.value, let listString = String(data: value, encoding: String.Encoding(rawValue: encoding)) {
                    //print("🍎🍎🍎 \(#function):: Result:\(listString)")
                    let list = listString.components(separatedBy: ";")
                    list.forEach { (string ) in
                        guard string.count > StockStateIndex.enumEndFlag.rawValue else {
                            return
                        }
                        
                        let stockInfo = StockInfo(string: string, isShowColor: self.showColor, isShowLog: self.showLog)
                        stockList.append(stockInfo)
                        //print(stockInfo)
                    }
                }
            } else {
                print("❌❌❌ \(Date()) \(NSStringFromClass(self.classForCoder))::\(String(describing: result.error))")
            }
            
            completion?(stockList)
            FPHudUtility.hideGifLoading()
        }
        
        let url = urlPrefix + stocks.joined(separator: ",")
        //print("🍎🍎🍎 \(#function):: url:\(url)")
        
        //【*】默认是URLEncoding，会导致解析错误； 需要使用JSONEncoding.default
        sessionManager.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData { (responseData) in
            requestComplete(responseData.response, responseData.result)
        }
    }
}
