//
//  String.swift
//  FPSwift
//
//  Created by jiangbin on 16/7/13.
//  Copyright © 2016年 iblue. All rights reserved.
//

extension String {

    func fp_count() -> Int {
        return self.characters.count
    }
    
    func fp_filterEmoji() -> String {
        let regex = try? NSRegularExpression(pattern: FP_EMOJI, options: .caseInsensitive)
        let result = regex?.stringByReplacingMatches(in: self, options: .reportCompletion, range:  NSMakeRange(0, self.characters.count), withTemplate: "")
        return result!
    }
    
    func fp_filterSapce() -> String {
        let regex = try? NSRegularExpression(pattern: FP_SPACE, options: .caseInsensitive)
        let result = regex?.stringByReplacingMatches(in: self, options: .reportCompletion, range:  NSMakeRange(0, self.characters.count), withTemplate: "")
        return result!
    }
    
    func fp_filterIllegalchar() -> String {
        let regex = try? NSRegularExpression(pattern: FP_ILLEGALCHAR, options: .caseInsensitive)
        let result = regex?.stringByReplacingMatches(in: self, options: .reportCompletion, range:  NSMakeRange(0, self.characters.count), withTemplate: "")
        return result!
    }
    
    /// 本地化的价格
    ///
    /// - Parameter price: 价格
    /// - Returns: 字符串，保留两位小数
    static func fp_localizedPrice(price: Double) -> String {
        return "￥" + String(format: "%.2f", price)
    }
    
    static func fp_localizePrice(price: Int) -> String {
        return "￥" + String(price)
    }
    
    /// 将表示十六进制的字符串，转十六进制data
    ///
    /// - Returns: Data
    func fp_hexData() -> Data {

        let data = NSMutableData()
        let string = NSString(string: self)
        var index = 0
        for _ in 0 ..< string.length - 1 {
            
            let range = NSMakeRange(index, 2)
            index = index + 1
            if index % 2 == 0 {
                continue
            }
            
            let hexStr = string.substring(with: range)
            let scanner = Scanner(string: hexStr)
            var intValue = UInt32(0)
            scanner.scanHexInt32(&intValue)
            data.append(&intValue, length: 1)
        }
        
        return data as Data
    }
    
    /// 获取md5值
    ///
    /// - Returns: String
    func fp_md5() -> String {
        
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return String(format: hash as String)
    }
    
    /// 字符数字转化成数字
    ///
    /// - Returns: 成功返回对应数字，失败返回0
    func fp_intValue() -> Int {
        if let intValue = Int(self) {
            return intValue
        }
        
        return 0
    }
    
    /// 简单的检验身份证信息
    ///
    /// - Returns: YES or NO
    func fp_simpleValidateIDCardNumber() -> Bool {
        let regex = "^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    /// 检验身份证信息：不检验地区，只检验最后一位
    ///
    /// - Returns: YES or NO
    func fp_validateIDCardNumber() -> Bool {
        if self.characters.count != 18 {
            return false
        }
        
        let codeArray = ["7","9","10","5","8","4","2","1","6","3","7","9","10","5","8","4","2"]
        let checkCodeDic = ["0":"1", "1":"0", "2":"X", "3":"9", "4":"8", "5":"7", "6": "6", "7":"5", "8":"4", "9":"3", "10":"2"]
        
        let scan = Scanner(string: self.substring(to: self.index(self.startIndex, offsetBy: 17)))
        
        var val: Int32 = 0
        let isNum = scan.scanInt32(&val) && scan.isAtEnd
        if !isNum {
            return false
        }
        
        var sumValue = 0
        for i in 0  ..< 17  {
            let startIndex = self.index(self.startIndex, offsetBy: i)
            let endIndex = index(startIndex, offsetBy: 1)
            let subString = self.substring(with: startIndex..<endIndex)
            sumValue = sumValue + subString.fp_intValue() * codeArray[i].fp_intValue()
        }
        
        let checkKey = String(sumValue%11)
        let obj = checkCodeDic[checkKey]
        if obj == nil {
            return false
        }else {
            if String(obj!) == self.substring(with: self.index(self.startIndex, offsetBy: 17) ..< self.index(self.startIndex, offsetBy: 18)).uppercased() {
                print("String Extension::ID Number is valid...")
                return true
            }
        }
        
        return false
    }
 
    /// 身份证透明处理
    ///
    /// - Returns: 处理后的身份信息
    func fp_transparentCardId() -> String {
        if self.characters.count >= 18 {
            let subString = self.substring(to: self.index(self.startIndex, offsetBy: 3))
            let suffix = String(repeating: "*", count: 15)
            return subString + suffix
        }
        
        return "***"
    }
}
