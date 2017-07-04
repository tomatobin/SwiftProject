//
//  FPTabbar.swift
//  FPSwift
//
//  Created by iblue on 16/7/10.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

protocol FPTabbarDelegate: NSObjectProtocol {
    func tabbarOnAction(_ tabbar: FPTabbar, centerButton: UIButton);
}

class FPTabbar: UITabBar {
    
    weak var fpDelegate: FPTabbarDelegate?
    
    
}
