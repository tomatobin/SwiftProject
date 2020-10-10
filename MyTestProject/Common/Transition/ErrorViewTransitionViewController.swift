//
//  ErrorViewTransitionViewController.swift
//  MyTestProject
//
//  Created by iblue on 2018/6/11.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class ErrorViewTransitionViewController: FPBaseController {

	private lazy var errorView1: UIView = {
		let view = UIView(frame: CGRect(x: 0, y: 200, width: self.view.bounds.width, height: 300))
		view.backgroundColor = UIColor.fp_yellowColor()
		return view
	}()
	
	private lazy var errorView2: UIView = {
		let view = UIView(frame: CGRect(x: 0, y: 200, width: self.view.bounds.width, height: 300))
		view.backgroundColor = UIColor.fp_mainRedColor()
		return view
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.addSubview(errorView1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func onGoError2View(_ sender: Any) {
		
		//transitionCrossDissolve
//		UIView.transition(from: errorView1, to: errorView2, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { _ in
//			self.errorView1.removeFromSuperview()
//			self.view.addSubview(self.errorView2)
//		}
		
		let animation = CATransition()
		animation.duration = 0.3
        animation.type = CATransitionType.fade
        animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.layer.add(animation, forKey: CATransitionType.fade.rawValue)
		
		self.view.addSubview(errorView2)
	}
	
	@IBAction func onGoError1View(_ sender: Any) {
//		UIView.transition(from: errorView2, to: errorView1, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { _ in
//			self.errorView2.removeFromSuperview()
//			self.view.addSubview(self.errorView1)
//		}
		
		let animation = CATransition()
		animation.duration = 0.3
        animation.type = CATransitionType.fade
        animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
		
        self.view.layer.add(animation, forKey: CATransitionType.fade.rawValue)
		
		errorView2.removeFromSuperview()
		
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
