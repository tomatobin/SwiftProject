//
//  NSObject+Extension.swift
//  FPSwift
//
//  Created by jiangbin on 17/3/10.
//  Copyright © 2017年 iblue. All rights reserved.
//

public extension NSObject{
    
    public class var fp_nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    public var fp_nameOfClass: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}
