//
//  FPTabbarContoller.swift
//  FPSwift
//
//  Created by iblue on 16/7/2.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class FPTabbarContoller: UITabBarController,FPTabbarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //以原始的图片渲染Tabbar的选中效果
        if let items = self.tabBar.items {
            for item in items {
                item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    //MARK: - Rotate
    override var shouldAutorotate : Bool {
        if self.selectedViewController != nil {
            return (self.selectedViewController?.shouldAutorotate)!
        }
        
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if self.selectedViewController != nil {
            return (self.selectedViewController?.supportedInterfaceOrientations)!
        }
     
        return .portrait
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if self.selectedViewController != nil {
            return (self.selectedViewController?.preferredStatusBarStyle)!
        }
      
        return .default
    }
}

extension FPTabbarContoller{
    //MARK: FPTabbarDelegate
    func tabbarOnAction(_ tabbar: FPTabbar, centerButton: UIButton) {
        ColorLog.green("Tabbar on center action!")
    }
}
