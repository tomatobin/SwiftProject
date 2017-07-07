//
//  WidgetsHudServiceProtocol.swift
//  MyTestProject
//
//  Created by iblue on 2017/7/7.
//  Copyright © 2017年 iblue. All rights reserved.
//

import UIKit
import BeeHive

@objc protocol WidgetsHudServiceProtocol: BHServiceProtocol {
    
    /// 自动消失的时间，Swift Protocol中的属性必须明确get或set
    var dismissTime: Double { get set }
    
}
