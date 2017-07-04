//
//  SpringController.swift
//  MyTestProject
//
//  Created by iblue on 2017/7/4.
//  Copyright © 2017年 iblue. All rights reserved.
//

import UIKit
import Spring

class SpringController: FPBaseController {

    @IBOutlet weak var loadingVew: UIView!
    @IBOutlet weak var button: SpringButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.button.addTarget(self, action: #selector(SpringController.onTouchUpInsideAction), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadingVew.showLoading()
    }
    
    func onTouchUpInsideAction() {
        self.swingAnimation()
    }
    
    func swingAnimation() {
        button.animation = Spring.AnimationPreset.Swing.rawValue
        button.curve = Spring.AnimationCurve.EaseInOut.rawValue
        button.animateFrom = false
        button.duration = 1.0
        button.repeatCount = 3
        button.animate()
    }
    
    var isBall = false
    func changeRadiusAnimation() {
        isBall = !isBall
        let animation = CABasicAnimation()
        let halfWidth = button.frame.width / 2
        let cornerRadius: CGFloat = isBall ? halfWidth : 10
        animation.keyPath = "cornerRadius"
        animation.fromValue = isBall ? 10 : halfWidth
        animation.toValue = cornerRadius
        animation.duration = 0.2
        button.layer.cornerRadius = cornerRadius
        button.layer.add(animation, forKey: "changeRadius")
    }

}
