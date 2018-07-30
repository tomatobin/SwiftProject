//
//  REMobileApiResultViewController.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/30.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class REMobileApiResultViewController: FPBaseController {
	
	public var function: String = ""
	
	public var jsonParams: String = ""

	@IBOutlet weak var resultTextView: UITextView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func request() {
		REServiceUtil.sharedInstance.post(funtion: function, encodeParams: jsonParams, success: { (result) in
			self.resultTextView.text = result
		}) { (error) in
			self.resultTextView.text = error.localizedDescription
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
