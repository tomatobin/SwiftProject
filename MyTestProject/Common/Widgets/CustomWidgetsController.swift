//
//  CustomWidgetsController.swift
//  MyTestProject
//
//  Created by iblue on 16/10/16.
//  Copyright © 2016年 iblue. All rights reserved.
//

import BeeHive
import MGJRouter

class CustomWidgetsController: FPBaseController {

    @IBOutlet weak var starsView: FPStarsView!
    @IBOutlet weak var roomSelectView: FPRoomSelectView!
    @IBOutlet weak var panoTopView: LCPanoTopView!
    @IBOutlet weak var bazierButtoin: UIButton!
    @IBOutlet weak var textView: FPTextViewPlaceholder!
    @IBOutlet weak var talkButtion: UIButton!
    
	@IBOutlet weak var timerCycleView: DHCycleTimerView!
	override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initStarsView()
        self.initRoomSelectView()
        self.initPanoTopView()
        self.initBazierButton()
        self.initTextView()
        self.initTalkButtion()
		self.initCycleTimerView()
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
//            self.presentBlurController()
//        })
    }
    
    func initTalkButtion() {
        self.talkButtion.setImage(UIImage(named: "livepreview_icon_speak_disable"), for: .normal)
        self.talkButtion.tag = 0
    }
    
    func initStarsView () {
        self.starsView.backgroundColor = UIColor.white
        let score = arc4random() % 6
        self.starsView.setScore(Int(score), animated: true)
    }
    
    func initRoomSelectView () {
        self.roomSelectView.backgroundColor = UIColor.fp_mainBlueColor()
        self.roomSelectView.updateView(.strip)
    }
    
    func initPanoTopView() {
        self.panoTopView.backgroundColor = UIColor.white
        self.panoTopView.disableButton(.left)
    }
    
    func initBazierButton() {
        self.bazierButtoin.addTarget(self, action: #selector(presentBlurController), for: .touchUpInside)
        self.startAnimation()
    }
	
	func initCycleTimerView() {
		timerCycleView.maxTime = 60
		timerCycleView.startTimer()
	}
    
    func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = NSNumber(value: 0.5 as Double)
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = Float(INT_MAX)
        animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
        self.bazierButtoin.layer.add(animation, forKey: "rotate")
    }
    
	@objc func presentBlurController() {
//        let blurController = FPBlurController()
//        blurController.setTransionStyle()
//        self.present(blurController, animated: true, completion: nil)
		
		let blurView = DHBlurViewContainer(frame: view.bounds)
		let contentView = UIView()
		contentView.backgroundColor = UIColor.white
		blurView.setupContent(view: contentView, height: 350)
		blurView.show(onView: view, animated: true)

    }
    
    func initTextView() {
        self.textView.placeholder = "这是一个自带PlaceHolder的TextView，是不是很不错的啊~"
    }
    
    @IBAction func onTalkAction(_ sender: Any) {
        
        let animation: CATransition = CATransition.init()
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
        animation.type = CATransitionType(rawValue: "oglFlip")
        self.talkButtion.layer.add(animation, forKey: "Flip")
        
        self.popAnimation(view: self.talkButtion)
        
        MGJRouter.openURL("my://widgets/hud?dismissTime=5&title=MGJRouter", withUserInfo: ["dissmissTime": Double(2.0),
                                                             "NavigationVc": self.navigationController as Any]) { result in
        }
        
    }
    
    //MARK: Animation
    func swingAnimation() {
       
    }
    
    func popAnimation(view: UIView) {
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        let scale1 =  CATransform3DMakeScale(0.5, 0.5, 1)
        let scale2 =  CATransform3DMakeScale(1.2, 1.2, 1)
        let scale3 =  CATransform3DMakeScale(0.9, 0.9, 1)
        let scale4 =  CATransform3DMakeScale(1.0, 1.0, 1)
        keyframeAnimation.values = [scale1, scale2, scale3, scale4]
        keyframeAnimation.keyTimes = [0, 0.5, 0.9, 1.0]
        keyframeAnimation.fillMode = CAMediaTimingFillMode.forwards
        keyframeAnimation.duration = 3
        view.layer.add(keyframeAnimation, forKey: "KeyframeAnimation")
    }
}
