//
//  FPNavigaionController.swift
//  FPSwift
//
//  Created by iblue on 16/6/4.
//  Copyright © 2016年 iblue. All rights reserved.
//  自定义导航Controller

import UIKit

class FPNavigaionController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.tintColor = UIColor.gray
        self.interactivePopGestureRecognizer!.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
        return self.viewControllers.count > 1
    }
    
    //MARK: Rotate Methods
    override var shouldAutorotate : Bool {
        return (self.visibleViewController?.shouldAutorotate)!
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return (self.visibleViewController?.supportedInterfaceOrientations)!
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.visibleViewController?.viewWillTransition(to: size, with: coordinator)
    }
    
}
