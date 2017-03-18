//
//  ColorLog.swift
//  FPSwift
//
//  Created by jiangbin on 16/6/14.
//  Copyright © 2016年 iblue. All rights reserved.
//

import Foundation

struct ColorLog {
    static let ESCAPE = "\u{001b}["
    
    static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    static let RESET_BG = ESCAPE + "bg;" // Clear any background color
    static let RESET = ESCAPE + ";"     // Clear any foreground or background color
    
    static func red<T>(_ object: T) {
        printLog("fg255,0,0", object: object)
    }
    
    static func green<T>(_ object: T) {
        printLog("fg0,255,0", object: object)
    }
    
    static func blue<T>(_ object: T) {
        printLog("fg0,0,255", object: object)
    }
    
    static func yellow<T>(_ object: T) {
        printLog("fg255,255,0", object: object)
    }
    
    static func purple<T>(_ object: T) {
        printLog("fg255,0,255", object: object)
    }
    
    static func cyan<T>(_ object: T) {
        printLog("fg0,255,255", object: object)
    }
    
    fileprivate static func printLog<C, T>(_ color: C, object: T){
        //print("\(ESCAPE)\(color);\(NSDate().fp_string(.Default)) \(object)\(RESET)")
        //Xcode8相关颜色插件失效，暂时改回普通打印
        print(object)
    }
}
