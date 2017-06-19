//
//  UIView+Ex.swift
//  MyTestProject
//
//  Created by jiangbin on 2017/6/19.
//  Copyright © 2017年 iblue. All rights reserved.
//

import Foundation

extension UIView {
    
    var fp_x: CGFloat {
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }get {
            return self.frame.origin.x
        }
    }
    
    var fp_y: CGFloat {
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }get {
            return self.frame.origin.y
        }
    }
    
    var fp_width: CGFloat {
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }get {
            return self.frame.size.width
        }
    }
    
    var fp_height: CGFloat {
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }get {
            return self.frame.size.height
        }
    }
    
    var fp_centerX: CGFloat {
        set{
            var center = self.center
            center.x = newValue
            self.center = center
        }get {
            return self.center.x
        }
    }
    
    var fp_centerY: CGFloat {
        set{
            var center = self.center
            center.y = newValue
            self.center = center
        }get {
            return self.center.y
        }
    }
}
