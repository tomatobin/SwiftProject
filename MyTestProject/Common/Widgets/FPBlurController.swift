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
        
        //Test Aescipher
        let pwd = "q12345678"
        let md5 = pwd.fp_md5()
        let aes = AESCipher.encrypt(content: pwd, withKey: "8d22415838638cbe579b1017c6f1738bc453b569ef38a23ddc08d56d357904a9")
        print("AES Result:\(aes)")
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
    
	@objc func onTapAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
