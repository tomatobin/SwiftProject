//
//  NSDictionary+Extension.swift
//  FPSwift
//
//  Created by jiangbin on 16/10/13.
//  Copyright © 2016年 iblue. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    /**
     将值转化为Int64, 失败返回0
     
     - parameter key: 键值
     
     - returns: 转化后的Int64值
     */
    func fp_int64Value(forKey key: String) -> Int64 {
        
        let value = self.object(forKey: key)
        if value is String {
            if let result = Int64(value as! String) {
                return result
            }
        }
        
        if value is NSNumber {
            return (value as! NSNumber).int64Value
        }
        
        return Int64(0)
    }
    
    /**
     将值转化为Int, 失败返回0
     
     - parameter key: 键值
     
     - returns: 转化后的Int值
     */
    func fp_integerValue(forKey key: String) -> Int {
        let value = self.object(forKey: key)
        if value is String {
            if let result = Int(value as! String) {
                return result
            }
        }
        
        if value is NSNumber {
            return (value as! NSNumber).intValue
        }
        
        return Int(0)
    }
    
    /**
     将值转化为Bool类型，转换失败返回false
     
     - parameter key: 键值
     
     - returns: 转化后的Bool值
     */
    func fp_boolValue(forKey key: String) -> Bool {
        
        let value = self.object(forKey: key)
        if value is NSString {
            let lowerCase = (value as! String).lowercased()
            if ["0", "false"].contains(lowerCase) {
                return false
            }
            if ["1", "true"].contains(lowerCase) {
                return true
            }
        }
        
        if value is NSNumber {
            return (value as! NSNumber).boolValue
        }
        
        return false
    }
    
    /**
     将值转化为Int64类型的时间，转换失败返回false
     
     - parameter key: 键值
     
     - returns: 转化后的Int64值
     */
    func fp_timeValue(forKey key: String) -> Int64 {
        var value = self.fp_int64Value(forKey: key)
        let strTime = String(value)
        
        //末尾有毫秒的，以000结束
        if strTime.fp_count() > 10 && value % 1000 == 0 {
            value = value / Int64(1000)
        }
        return value
    }
    
    /**
     取String值，减少判断
     
     - parameter key: 键值
     
     - returns: String，转化不成功返回""
     */
    func fp_stringValue(forKey key: String) -> String {
        let value = self.object(forKey: key)
        if value is String {
            return value as! String
        }
        
        if value is NSNumber {
            return String(describing: value)
        }

        return ""
    }
}
