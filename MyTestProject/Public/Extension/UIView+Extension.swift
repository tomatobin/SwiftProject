//
//  UIView+Extension.swift
//  FPSwift
//
//  Created by iblue on 16/9/16.
//  Copyright © 2016年 iblue. All rights reserved.
//

import Foundation

extension UIView {
    
    func fp_removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    /**
     设置视图可以操作：userInteractionEnabled的属性置为true，alpha置为1
     */
    func fp_setEnable() {
        self.isUserInteractionEnabled = true
        self.alpha = 1
    }
    
    /**
     设置视图不可以操作：userInteractionEnabled的属性置为false，默认值为0.6
     - parameter alpha: 透明度
     */
    func fp_setDisable(_ alpha: CGFloat = 0.6) {
        self.isUserInteractionEnabled = false
        self.alpha = alpha
    }
    
    /**
     在view上加载loading效果
     
     - parameter offset: 相对于中心点的偏移
     */
    func fp_showLoading(_ offset: CGPoint) {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.tag = 0xFF
        let x = (self.bounds.width - 25) / 2.0 + offset.x
        let y = (self.bounds.height - 25) / 2.0 + offset.y
        indicator.frame = CGRect(x: x, y: y, width: 25, height: 25)
        self.addSubview(indicator)
        
        //禁用
        self.fp_setDisable()
    }
    
    /**
     移除视图上的loading
     */
    func fp_hideLoading() {
        if let indicator = self.viewWithTag(0xFF){
            indicator.removeFromSuperview()
        }
        
        //启用
        self.fp_setEnable()
    }
}
