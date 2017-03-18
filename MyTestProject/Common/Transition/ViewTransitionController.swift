//
//  ViewTransitionController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/11.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class ViewTransitionController: FPBaseController {
    
    @IBOutlet weak var onNextBtn: UIButton!
    var stepOneView: UILabel!
    var stepTwoView: UILabel!
    
    let rightFrame: CGRect = CGRect(x: FP_SCREEN_WIDTH, y: 200, width: 200, height: 60)
    let centerFrame: CGRect = CGRect(x: (FP_SCREEN_WIDTH - 200)/2.0, y: 200, width: 200, height: 60)
    let leftFrame: CGRect = CGRect(x: -200, y: 200, width: 200, height: 60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.fp_darkBgColor()
        self.initUIWidgets()
        
        self.showView(stepOneView)
    }
    
    func initUIWidgets() {
        stepOneView = UILabel(frame: self.rightFrame)
        stepOneView.text = "第一步，我要从右边显示出来，从左边隐藏"
        stepOneView.numberOfLines = 0
        stepOneView.font = UIFont.systemFont(ofSize: 17)
        stepOneView.textColor = UIColor.white
        self.view.addSubview(stepOneView)
        
        stepTwoView = UILabel(frame: self.rightFrame)
        stepTwoView.numberOfLines = 0
        stepTwoView.text = "第二步，我要从右边显示出来，从左边隐藏"
        stepTwoView.font = UIFont.systemFont(ofSize: 17)
        stepTwoView.textColor = UIColor.white
        self.view.addSubview(stepTwoView)
        
        self.onNextBtn.alpha = 0
    }
    
    func showView(_ view: UIView) {
        view.alpha = 0.5
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
            view.alpha = 1
            view.frame = self.centerFrame
            self.onNextBtn.alpha = 1
        }, completion: {_ in
        })
    }
    
    @IBAction func onNextAction(_ sender: AnyObject) {
        self.showSecondView()
    }
    
    func showSecondView() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
            self.stepOneView.alpha = 0
            self.stepOneView.frame = self.leftFrame
            self.onNextBtn.alpha = 0
        }, completion: {_ in
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
                self.stepTwoView.frame = self.centerFrame
                self.onNextBtn.alpha = 1
            }, completion: {_ in
                    
            })
        })
    }
    
    func hideView(_ view: UIView) {
        
    }
    
    //MARK: 解决导航栏手势滑动过程中不显示的问题
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //二级页面通过右滑手势pop回来，滑动过程中 导航条会若隐若现
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
}
