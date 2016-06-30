//
//  FPBaseController.swift
//  FPSwift
//
//  Created by iblue on 16/6/3.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class FPBaseController: UIViewController {
    
    private var rotateLocked = Bool(false) //初始化不锁屏
    
    deinit{
        print("💔💔 %@ deinit 💔💔", NSStringFromClass(self.classForCoder))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assure view below navigation bar
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = true
        self.edgesForExtendedLayout = .None
        self.navigationController?.navigationBar.translucent = false
        self.tabBarController?.tabBar.translucent = false
        
        self.view.backgroundColor = UIColor.fp_colorWithHexString("EFEFF4")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Public Methods
    func lockRotate(){
        self.rotateLocked = true
    }
    
    func unlockRotate(){
        self.rotateLocked = false
    }
    
    //MARK: Rotate
    override func shouldAutorotate() -> Bool {
        return self.rotateLocked
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
}
