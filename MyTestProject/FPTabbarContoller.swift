//
//  FPTabbarContoller.swift
//  FPSwift
//
//  Created by iblue on 16/7/2.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class FPTabbarContoller: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
