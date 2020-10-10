//
//  DHAddGuideView.swift
//  LeChangeOverseas
//
//  Created by iblue on 2018/6/5.
//  Copyright © 2018年 Zhejiang bingo Technology Co.,Ltd. All rights reserved.
//

import UIKit

enum DHAddGuideActionType {
	case next
	case detail
	case check
}

protocol DHAddGuideViewDelegate: NSObjectProtocol {
	
	func guideView(view: DHAddGuideView, action: DHAddGuideActionType)
}

class DHAddGuideView: UIView {
	
	/// 是否选中
	public var isChecked: Bool {
		get{
			return checkButton.isSelected
		} set {
			checkButton.isSelected = newValue
		}
	}

	@IBOutlet weak var topImageView: UIImageView!
	@IBOutlet weak var topTipLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var detailButton: UIButton!
	@IBOutlet weak var checkButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	
	var userInfo: Any?
	
	public weak var delegate: DHAddGuideViewDelegate?
	
//	deinit {
//		dh_printDeinit(self)
//	}
	
	public static func xibInstance() -> DHAddGuideView {
		let view = Bundle.main.loadNibNamed("DHAddGuideView", owner: nil, options: nil)!.first as! DHAddGuideView
		return view
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.detailButton.setTitleColor(UIColor.orange, for: .normal)
		
		//配置颜色、样式
//		nextButton.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
//		nextButton.backgroundColor = DHModuleConfig.shareInstance().commonButtonColor()
		checkButton.setImage(UIImage(named: "adddevice_box_checkbox"), for: .normal)
		checkButton.setImage(UIImage(named: "adddevice_box_checkbox_checked"), for: .selected)
		
		//默认不显示check按钮、描述文字、详情按钮、重置视图
		self.setCheckHidden(hidden: true)
		self.descriptionLabel.text = nil
		self.setDetailButtonHidden(hidden: true)
	}
	
	//MARK: Actions
	@IBAction func onCheckAction(_ sender: Any) {
		checkButton.isSelected = !checkButton.isSelected
		nextButton.isEnabled = checkButton.isSelected
		delegate?.guideView(view: self, action: .check)
	}
	
	@IBAction func onNextAction(_ sender: Any) {
		delegate?.guideView(view: self, action: .next)
	}
	
	@IBAction func onDetailAction(_ sender: Any) {
		delegate?.guideView(view: self, action: .detail)
	}
	
	//MARK: Configurations
	/// 设置确认按钮隐藏，隐藏时nextButton直接可以点击
	///
	/// - Parameter hidden: true/false
	public func setCheckHidden(hidden: Bool) {
		checkButton.isHidden = hidden
		nextButton.isEnabled = hidden
	}
	
	public func setDetailButtonHidden(hidden: Bool) {
		detailButton.isHidden = hidden
	}
	
	/// 设置详情按钮的文字，
	///
	/// - Parameter text: 文字
	///   - useUnderline: 是否使用下划线
	public func setDetailButton(text: String?, useUnderline: Bool = true) {
		guard text != nil else {
			return
		}
		
		if useUnderline {
			let attrString = NSMutableAttributedString(string: text!)
			let range = NSMakeRange(0, text!.count)
            let number = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
            attrString.addAttributes([NSAttributedString.Key.underlineStyle: number,
                                      NSAttributedString.Key.foregroundColor: UIColor.orange], range: range)
			detailButton.setAttributedTitle(attrString, for: .normal)
		} else {
			detailButton.setTitle(text, for: .normal)
		}
	}
}
