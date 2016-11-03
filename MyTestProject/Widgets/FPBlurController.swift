//
//  FPBlurController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/11/3.
//  Copyright © 2016年 iblue. All rights reserved.
//

class FPBlurController: FPBaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        self.setupBlurEffect()
        self.addTapGesture()
    }
    
    func setTransionStyle() {
        self.modalPresentationStyle = .OverFullScreen
        self.modalTransitionStyle = .CrossDissolve
    }
    
    /**
     设置模糊效果
     */
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .Light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.bounds
        self.view.addSubview(visualEffectView)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func onTapAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
