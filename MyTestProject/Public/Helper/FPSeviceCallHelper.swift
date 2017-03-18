//
//  FPSeviceCallHelper.swift
//  FPSwift
//
//  Created by iblue on 16/10/23.
//  Copyright © 2016年 iblue. All rights reserved.
//  拨打服务电话

class FPSeviceCallHelper: NSObject {
    
    class func showCallHelper(_ serviceURL: String) {
        UIApplication.shared.openURL(URL(string: serviceURL)!)
    }
}
