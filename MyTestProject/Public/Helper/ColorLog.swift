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
        print("\(ESCAPE)fg255,0,0;\(object)\(RESET)")
    }
    
    static func green<T>(_ object: T) {
        print("\(ESCAPE)fg0,255,0;\(object)\(RESET)")
    }
    
    static func blue<T>(_ object: T) {
        print("\(ESCAPE)fg0,0,255;\(object)\(RESET)")
    }
    
    static func yellow<T>(_ object: T) {
        print("\(ESCAPE)fg255,255,0;\(object)\(RESET)")
    }
    
    static func purple<T>(_ object: T) {
        print("\(ESCAPE)fg255,0,255;\(object)\(RESET)")
    }
    
    static func cyan<T>(_ object: T) {
        print("\(ESCAPE)fg0,255,255;\(object)\(RESET)")
    }
}
