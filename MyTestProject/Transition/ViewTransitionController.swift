//
//  ViewTransitionController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/11.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class ViewTransitionController: FPBaseController {
    
    @IBOutlet weak var stepOneView: UILabel!
    @IBOutlet weak var stepTwoView: UILabel!
    
    let rightFrame: CGRect = CGRect(x: FP_SCREEN_WIDTH, y: 200, width: 100, height: 40)
    let centerFrame: CGRect = CGRect(x: (FP_SCREEN_WIDTH - 100)/2.0, y: 200, width: 100, height: 40)
    let leftFrame: CGRect = CGRect(x: -100, y: 200, width: 100, height: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.fp_darkBgColor()
        
        self.stepOneView.frame = rightFrame
        self.stepTwoView.frame = rightFrame
        
        self.showView(stepOneView)
    }
    
    func showView(view: UIView) {
        view.frame = rightFrame
        UIView.transitionWithView(self.stepOneView, duration: 0.3, options: .TransitionFlipFromLeft, animations: {
            view.frame = self.centerFrame
            }, completion: { _ in
        })
    }
    
    func hideView(view: UIView) {
        
    }
}

extension ViewTransitionController{
    //MARK: 解决导航栏手势滑动过程中不显示的问题
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //二级页面通过右滑手势pop回来，滑动过程中 导航条会若隐若现
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
}
