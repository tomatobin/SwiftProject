//
//  LightButtonController.swift
//  MyTestProject
//
//  Created by iblue on 2018/6/12.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class LightButtonController: FPBaseController {
	
	var failureView: DHWifiConnectFailureView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.edgesForExtendedLayout = []
		initFailureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	func initFailureView() {
		failureView = DHWifiConnectFailureView.xibInstance()
		failureView.frame = view.bounds
		view.addSubview(failureView)
		failureView.setFailureType(type: .overseasA)
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
