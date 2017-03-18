//
//  UINavigationController+Extenstion.swift
//  FPSwift
//
//  Created by iblue on 16/10/12.
//  Copyright © 2016年 iblue. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    /**
     检测导航栈中是否有对应class类的controller，并返回
     
     - parameter aClass: 检测的类
     
     - returns: 对应的controller，
     */
    func fp_containController(_ aClass: AnyClass) -> UIViewController? {
        for controller in self.viewControllers {
            if controller.isKind(of: aClass) {
                return controller
            }
        }
        
        return nil
    }
}
