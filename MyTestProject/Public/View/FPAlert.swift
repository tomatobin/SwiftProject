//
//  FPAlertView.swift
//  FPSwift
//
//  Created by jiangbin on 16/10/24.
//  Copyright © 2016年 iblue. All rights reserved.
//  封装不同类型的第三方库，方便调用

import UIKit


class FPAlert: NSObject {
    
    class func initAlertController(_ title: String?, message: String?, canelAction: @escaping ()->(), confirmAction: @escaping ()->() ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
            canelAction()
        }))
        
        alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { action in
            confirmAction()
        }))
        
        return alert
    }
    
}
