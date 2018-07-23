//
//  FPReverseController.swift
//  MyTestProject
//
//  Created by iblue on 2017/7/4.
//  Copyright © 2017年 iblue. All rights reserved.
//

import UIKit

class FPReverseController: FPBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "逆向"
		self.testVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func testVC() {
		let vc = DHInputSNViewController.storyboardInstance()
		self.addChildViewController(vc)
		
		self.view.addSubview(vc.view)
		
		vc.view.snp.makeConstraints { (make) in
			make.edges.equalTo(self.view)
		}
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
