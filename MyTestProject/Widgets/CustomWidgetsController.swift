//
//  CustomWidgetsController.swift
//  MyTestProject
//
//  Created by iblue on 16/10/16.
//  Copyright © 2016年 iblue. All rights reserved.
//

class CustomWidgetsController: FPBaseController {

    @IBOutlet weak var starsView: FPStarsView!
    @IBOutlet weak var roomSelectView: FPRoomSelectView!
    @IBOutlet weak var panoTopView: LCPanoTopView!
    @IBOutlet weak var bazierButtoin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initStarsView()
        self.initRoomSelectView()
        self.initPanoTopView()
        self.initBazierButton()
    }
    
    func initStarsView () {
        self.starsView.backgroundColor = UIColor.whiteColor()
        let score = rand() % 6
        self.starsView.setScore(Int(score), animated: true)
    }
    
    func initRoomSelectView () {
        self.roomSelectView.backgroundColor = UIColor.fp_mainBlueColor()
        self.roomSelectView.updateView(.Strip)
    }
    
    func initPanoTopView() {
        self.panoTopView.backgroundColor = UIColor.whiteColor()
        self.panoTopView.disableButton(.Left)
    }
    
    func initBazierButton() {
        self.startAnimation()
    }
    
    func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(double: 0.5)
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = Float(INT_MAX)
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        self.bazierButtoin.layer.addAnimation(animation, forKey: "rotate")
    }
}
