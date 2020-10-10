//
//  IoTApiResultViewController.swift
//  MyTestProject
//
//  Created by iblue on 2020/6/23.
//  Copyright © 2020 iblue. All rights reserved.
//

import UIKit
import Alamofire

class IoTApiResultViewController: FPBaseController {

    public var function: String = ""
    public var dicParams: [String : Any] = [String : Any]()
    public var jsonData: Data?
    public var host: String = ""
    public var headers: [String: String] = [String : String]()
    
    @IBOutlet weak var resultTextView: UITextView!
    
    var sessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        //请求超时时间15秒
        configuration.timeoutIntervalForRequest = 60
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultTextView.delegate = self
        request()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FPHudUtility.hideHuds(view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func request() {
        FPHudUtility.hideGifLoading()
        _ = FPHudUtility.showGifLoading(view, gifName: "Loading_rabbit")
        
        let url = host + function
        
        let requestComplete: (HTTPURLResponse?, Result<Any>) -> Void = { response, result in
            if let response = response {
                for (field, value) in response.allHeaderFields {
                    print("\(field): \(value)")
                }
            }
            
            if result.isSuccess {
                print("🍎🍎🍎 \(#function):: Result:\(String(describing: result.value))")
                
                var jsonString: String = ""
                if let value = result.value,
                    let data = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
                    jsonString = String(data: data, encoding: .utf8) ?? ""
                    print("🍎🍎🍎 \(#function):: Result:\(jsonString)")
                    self.resultTextView.text = jsonString
                }
                
                if let value = result.value as? [[String: Any]] {
                    //IOT
                     print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::IOT JSON")
                } else if let value = result.value as? [String: Any] {
                    //SaaS，如{"code":10000,"data":{"sessionId":"973330b441256729e74394b72d520b25","username":"lcm81cqgh5x8f6q4x44a52tipphipmae","token":"d4mkha4dcie2gim95ha2n4bzlem2lklb"},"desc":"success"}
                    let code = value["code"] as? String ?? ""
                    let desc = value["desc"] as? String ?? ""
                    print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::SaaS-\(code), \(desc)")
                    
                    if let data = value["data"] as? [String: String] {
                        let sessionId = data["sessionId"] ?? ""
                        let username = data["username"] ?? ""
                        let token = data["token"] ?? ""
                        print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::data-\(sessionId), \(username), \(token)")
                    }
                    
                }
                
            } else {
                self.resultTextView.text = String(describing: result.error)
                print("❌❌❌ \(Date()) \(NSStringFromClass(self.classForCoder))::\(String(describing: result.error))")
            }
            
            FPHudUtility.hideGifLoading()
        }
        
        //jsonData不为空时，直接使用
        if jsonData != nil {
            print("🍎🍎🍎 \(#function):: url:\(url), parameters:\(jsonData!)")
            
            var originRequest: URLRequest?
            do {
                originRequest = try URLRequest(url: url, method: .post, headers: headers)
            } catch  {
                print("❌❌❌ \(Date()) \(NSStringFromClass(self.classForCoder))::Init request failed...")
            }
            
            if var request = originRequest {
                request.httpBody = jsonData
                sessionManager.request(request).responseJSON { (responseData) in
                    requestComplete(responseData.response, responseData.result)
                }
            }
        } else {
            print("🍎🍎🍎 \(#function):: url:\(url), parameters:\(dicParams)")
            
            //【*】默认是URLEncoding，会导致解析错误； 需要使用JSONEncoding.default
            sessionManager.request(url, method: .post, parameters: dicParams, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseData) in
                requestComplete(responseData.response, responseData.result)
            }
        }
    }
}

extension IoTApiResultViewController: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

