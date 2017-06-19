//
//  UIScrollView+Refresh.swift
//  MyTestProject
//
//  Created by jiangbin on 2017/6/19.
//  Copyright © 2017年 iblue. All rights reserved.
//

import Foundation

extension UIScrollView {
    
    var fp_header: FPRefreshComponent{
        set{
            newValue.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
            self.addSubview(newValue)
            objc_setAssociatedObject(self, FPRefreshComponentKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }get{
            return objc_getAssociatedObject(self, FPRefreshComponentKey) as! FPRefreshComponent
        }
    }
}

