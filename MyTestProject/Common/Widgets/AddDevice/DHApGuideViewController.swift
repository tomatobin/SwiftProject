//
//  DHApGuideViewController.swift
//  MyTestProject
//
//  Created by iblue on 2018/6/15.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class DHApGuideViewController: DHGuideBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	//MARK: DHGuideBaseVCProtocol
	override func tipImageName() -> String? {
		return "adddevice_failhrlp_default"
	}
	
	override func tipImageUrl() -> String? {
		return ""
	}
}
