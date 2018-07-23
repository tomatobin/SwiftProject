//
//  DHInputSNViewController.swift
//  LCIphoneAdhocIP
//
//  Created by iblue on 2018/6/4.
//  Copyright © 2018年 dahua. All rights reserved.
//	手动输入序列号

import UIKit

class DHInputSNViewController: FPBaseController {

	@IBOutlet weak var snTipLabel: UILabel!
	@IBOutlet weak var qrCodeImageView: UIImageView!
	@IBOutlet weak var inputSnTextField: LCTextField!
	@IBOutlet weak var boxTipLabel: UILabel!
	@IBOutlet weak var nextStepButton: UIButton!
	@IBOutlet weak var autoKeyboardView: DHAutoKeyboardView!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	
	public static func storyboardInstance() -> DHInputSNViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "DHInputSNViewController")
		return controller as! DHInputSNViewController
	}
	
	//MARK: Life Cycles
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

		//按钮样式配置
		nextStepButton.layer.cornerRadius = 22.5
		
		inputSnTextField.layer.borderWidth = 0.5
		inputSnTextField.layer.borderColor = UIColor.lightGray.cgColor
		inputSnTextField.autocapitalizationType = .allCharacters
		inputSnTextField.leftViewMode = .always
		inputSnTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 45))

		inputSnTextField.textChanged = { [unowned self] text in
			let snText = text ?? ""
		}
		
		autoKeyboardView.relatedView = nextStepButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	//MAKR: Actions
	@IBAction func onNextAction(_ sender: Any) {
		
	}
}
