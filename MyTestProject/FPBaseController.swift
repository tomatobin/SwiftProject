//
//  FPBaseController.swift
//  FPSwift
//
//  Created by iblue on 16/6/3.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class FPBaseController: UIViewController {
    
    fileprivate var rotateLocked = Bool(false) //初始化不锁屏
    
    deinit{
        print("💔💔 %@ deinit 💔💔", NSStringFromClass(self.classForCoder))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assure view below navigation bar
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = true
        self.edgesForExtendedLayout = UIRectEdge()
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        
        self.view.backgroundColor = UIColor.fp_colorWithHexString("EFEFF4")
        
        //导航栏
        if let button = self.naviRightButton() {
            let rightItem = UIBarButtonItem(customView: button)
            self.navigationItem.rightBarButtonItem = rightItem
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Navigation
    func naviRightButton() -> UIButton? {
        return nil;
    }
    
    //MARK: Public Methods
    func lockRotate(){
        self.rotateLocked = true
    }
    
    func unlockRotate(){
        self.rotateLocked = false
    }
    
    //MARK: Rotate
    override var shouldAutorotate : Bool {
        return self.rotateLocked
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
}
