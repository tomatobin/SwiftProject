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
        
        self.view.backgroundColor = UIColor.clear
        self.setupBlurEffect()
        self.addTapGesture()
    }
    
    func setTransionStyle() {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    /**
     设置模糊效果
     */
    fileprivate func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.bounds
        self.view.addSubview(visualEffectView)
    }
    
    fileprivate func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func onTapAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
