//
//  DHGuideBaseViewController.swift
//  LeChangeOverseas
//
//  Created by iblue on 2018/6/5.
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	引导页基类

import UIKit

class DHGuideBaseViewController: DHAddBaseViewController,DHGuideBaseVCProtocol,DHAddGuideViewDelegate {

	private var guideView: DHAddGuideView = DHAddGuideView.xibInstance()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.view.addSubview(guideView)
		guideView.frame = self.view.bounds
		
		//配置引导图
		self.setupGuideView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setupGuideView() {
		guideView.delegate = self
		
		if tipImageUrl() != nil, tipImageUrl()!.length != 0 {
			//guideView.topImageView.lc_setImage(withUrl: tipImageUrl(), placeholderImage: tipImageName(), toDisk: true)
		} else if let imageName = tipImageName() {
			guideView.topImageView.image = UIImage(named: imageName)
		} else {
			guideView.topImageView = nil
		}
		
		guideView.topTipLabel.text = tipText()
		guideView.descriptionLabel.text = descriptionText()
		
		guideView.setDetailButton(text: detailText(), useUnderline: false)
		guideView.setDetailButtonHidden(hidden: isDetailHidden())
		guideView.checkButton.setTitle(checkText(), for: .normal)
		
		guideView.setCheckHidden(hidden: isCheckHidden())
		guideView.nextButton.isHidden = isNextStepHidden()
		guideView.nextButton.setTitle(nextStepText(), for: .normal)
	}
	
	internal func setNextButton(enable: Bool) {
		//guideView.nextButton.dh_enable = enable
	}
	
	internal func setCheckButton(enable: Bool) {
		guideView.checkButton.isEnabled = enable
	
		//复选按钮不可点击时，下一步按钮也需要不可点击
		if enable == false {
			guideView.checkButton.isSelected = false
			guideView.nextButton.isEnabled = false
		}
	}
	
	//MARK: DHAddGuideViewDelegate
	internal func guideView(view: DHAddGuideView, action: DHAddGuideActionType) {
		if action == .next {
			nextStepAction()
		} else if action == .detail {
			detailAction()
		}
	}
	
	//MARK: DHGuideBaseVCProtocol
	func tipText() -> String? {
		return "Please input tip text..."
	}
	
	func tipImageUrl() -> String? {
		return nil
	}
	
	func tipImageName() -> String? {
		return nil
	}
	
	func descriptionText() -> String? {
		return nil
	}
	
	func detailText() -> String? {
		return "Please input detail text..."
	}
	
	func checkText() -> String? {
		return "Plase input check text..."
	}
	
	func detailImageUrl() -> String? {
		return ""
	}
	
	func isCheckHidden() -> Bool {
		return false
	}
	
	func isDetailHidden() -> Bool {
		return true
	}
	
	func nextStepText() -> String? {
		return "TODO：下一步" //使用默认的"下一步"
	}
	
	func isNextStepHidden() -> Bool {
		return false
	}
	
	func nextStepAction() {
		//Override in inherit
	}
	
	func detailAction() {
		//Override in inherit
	}
}
