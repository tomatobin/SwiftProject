//
//  ImouMethodListModel.swift
//  MyTestProject
//
//  Created by iblue on 2020/7/7.
//  Copyright © 2020 iblue. All rights reserved.
//

import UIKit
import CocoaSecurity

enum ImouURI: String {
    case getToken = "/pcs/v1/user.account.GetToken"
    
    static func allURI() -> [ImouURI] {
        return [.getToken]
    }
}

struct ImouClientUA {
    var clientType = "phone"
    var clientVersion = "5.10.000"
    var clientOV = "iOS 10.3"
    var clientOS = "IOS"
    var terminalModel = "iPhone"
    var terminalId = "2284CD8B-265E-4E8E-B1CA-DD55736EA223"
    var appid = "easy4ipbaseapp"
    var project = "Base"
    var language = "zh_CN"
    var clientProtocolVersion = "V5.1.0"
    var timezoneOffset = "3600"
    
    func base64String() -> String {
        var dicUA = [String: Any]()
        dicUA["clientType"] = clientType
        dicUA["clientVersion"] = clientVersion
        dicUA["clientOV"] = clientOV
        dicUA["clientOS"] = clientOS
        dicUA["terminalModel"] = terminalModel
        dicUA["terminalId"] = terminalId
        dicUA["appid"] = appid
        dicUA["project"] = project
        dicUA["language"] = language
        dicUA["clientProtocolVersion"] = clientProtocolVersion
        dicUA["timezoneOffset"] = timezoneOffset

        let data = try? JSONSerialization.data(withJSONObject: dicUA, options: .prettyPrinted)
        let base64 = data?.base64EncodedString() ?? ""
        
        return base64
    }
}

class ImouMethodListModel: NSObject {
    
    /// 根据方法，拼装请求体，转化成json格式的
    /// - Parameter uri: 方法
    func body(uri: ImouURI) -> Data? {
        var data = [String: Any]()
        data["data"] = [String: Any]()
        
        if uri == .getToken {
            var gpsInfo = [String: Any]()
            var params = [String: Any]()
            params["longitude"] = 0
            params["latitude"] = 0
            gpsInfo["gpsInfo"] = params
            data["data"] = gpsInfo
        }
        
        //为保持各端统一，options传空
        return try? JSONSerialization.data(withJSONObject: data, options: [])
    }
    
    /// 根据方法，拼装请求头
    /// - Parameters:
    ///   - uri: 方法
    ///   - username: 用户名或token（明文）
    ///   - token: 密码或sk（明文的密码需要md5）
    ///   - body: 参数体
    func headers(uri: ImouURI, username: String, token: String, body: Data?) -> [String: String] {
        let password = token.fp_md5()
        
        //ClientUA
        let clientUA = ImouClientUA()
        let clientUABase64 = clientUA.base64String()
        
        //Body base64(md5(body))，data中可能含有不标准的json，如double、null等，需要使用fragmentsAllowed
        //将body转成二进制，再md5，再base64
        var md5Content = ""
        
        if let bodyData = body {
            let originString = String(data: bodyData, encoding: .utf8) ?? ""
            let bodyMd5 = CocoaSecurity.md5(with: bodyData)
            md5Content = bodyMd5?.base64 ?? ""
            print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::originString: \(originString)")
            print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::Base64(md5(Content)): \(md5Content)")
        }

        let method = "POST"
        let type = "application/json"
        let apiVersion = 0
        
        //0时区处理
        let timeZone = TimeZone.current
        let timeOffset = timeZone.secondsFromGMT(for: Date())
        let date = Date().addingTimeInterval(TimeInterval(-timeOffset))
        let dateTime = date.fp_string("yyyy-MM-dd'T'HH:mm:ss'Z'")
        
        //nonce生成，32位
        let nonce = randomNonce(length: 32)
        
        var saasSign = "\(method)\n\(uri.rawValue)\n\(md5Content)\n\(type)\nx-pcs-apiver:\(apiVersion)\nx-pcs-client-ua:\(clientUABase64)\n"
        saasSign = saasSign + "x-pcs-date:\(dateTime)\nx-pcs-nonce:\(nonce)\nx-pcs-username:\(username)\n"
        
        print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::\(saasSign)")
        
        //Sign生成：Base65(SHA256())
        let sha256 = CocoaSecurity.hmacSha256(saasSign, hmacKey: password)
        let base64SaasSign = sha256?.base64 ?? ""
        
        var headers = [String: String]()
        headers["Content-MD5"] = md5Content
        headers["x-pcs-username"] = username
        headers["x-pcs-apiver"] = "\(apiVersion)"
        headers["x-pcs-nonce"] = nonce
        headers["x-pcs-date"] = dateTime
        headers["x-pcs-signature"] = base64SaasSign
        headers["x-pcs-client-ua"] = clientUABase64
        
        //增加额外HTTP控制参数
        headers["Content-Type"] = "application/json"
        return headers
    }

    
    /// 生成随机nonce
    /// - Parameter length: 长度
    func randomNonce(length: Int = 32) -> String {
        let buffer = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let bufferCount = UInt32(buffer.count)
        var nonce = ""
        
        let startIndex = buffer.startIndex
        for _ in 0..<length {
            let random = Int(arc4random() % bufferCount)
            let stringIndex = buffer.index(startIndex, offsetBy: random)
            let alpha = buffer[stringIndex]
            nonce.append(alpha)
        }
        
        print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder)):: randomNonce: \(nonce)")
        return nonce
    }
}

