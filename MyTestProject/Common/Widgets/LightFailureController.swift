//
//  LightFailureController.swift
//  MyTestProject
//
//  Created by iblue on 2018/6/13.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class LightFailureController: FPBaseController {

	public var failureType: DHWifiConnectFailureType = .tp1
	
  	var failureView: DHWifiConnectFailureView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupFailureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setupFailureView() {
		failureView = DHWifiConnectFailureView.xibInstance()
		failureView.frame = view.bounds
		view.addSubview(failureView)
		failureView.setFailureType(type: failureType)
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
