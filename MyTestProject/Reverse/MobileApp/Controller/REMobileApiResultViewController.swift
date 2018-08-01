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
		resultTextView.delegate = self
		request()
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		FPHudUtility.hideHuds(view)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func request() {
		_ = FPHudUtility.showGifLoading(view, gifName: "Loading_rabbit")
		REServiceUtil.sharedInstance.post(funtion: function, encodeParams: jsonParams, success: { (result) in
			self.resultTextView.text = result
			FPHudUtility.hideHuds(self.view)
		}) { (error) in
			self.resultTextView.text = error?.localizedDescription
			FPHudUtility.hideHuds(self.view)
		}
	}
}

extension REMobileApiResultViewController: UITextViewDelegate {
	
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		textView.resignFirstResponder()
		return true
	}
}
