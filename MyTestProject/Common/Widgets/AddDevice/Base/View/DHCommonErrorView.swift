//
//  DHCommonErrorView.swift
//  LeChangeOverseas
//
//  Created by iblue on 2018/6/8.
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	能用的错误页面，适用于图片、文字、按钮固定的场景

import UIKit

protocol DHCommonErrorViewDelegate: NSObjectProtocol {
	
	/// 确定点击事件
	///
	/// - Parameters:
	///   - errorView: self
	func errorViewOnConfirm(errorView: DHCommonErrorView)
	
	/// FAQ点击事件
	///
	/// - Parameters:
	///   - errorView: self
	func errorViewOnFAQ(errorView: DHCommonErrorView)
}

class DHCommonErrorView: UIView {
	
	public var delegate: DHCommonErrorViewDelegate?

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var confrimButton: UIButton!
	@IBOutlet weak var faqButton: UIButton!
	
	public static func xibInstance() -> DHCommonErrorView {
		let view = Bundle.main.loadNibNamed("DHCommonErrorView", owner: nil, options: nil)!.first as! DHCommonErrorView
		return view
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		//配置颜色、样式
//		confrimButton.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
//		confrimButton.backgroundColor = DHModuleConfig.shareInstance().commonButtonColor()
		
		//默认不显示detail
		detailLabel.text = nil
	}
	
	@IBAction func onConfirmAction(_ button: UIButton) {
		delegate?.errorViewOnConfirm(errorView: self)
	}
	
	@IBAction func onFAQAction(_ sender: Any) {
		delegate?.errorViewOnFAQ(errorView: self)
	}
	
	public func dismiss(animated: Bool) {
		if animated {
			let animation = CATransition()
			animation.duration = 0.3
			animation.type = kCATransitionFade
			animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
			self.superview?.layer.add(animation, forKey: kCATransitionFade)
		}
		
		self.removeFromSuperview()
	}
	
	public func showOnView(superView: UIView, animated: Bool) {
		if animated {
			let animation = CATransition()
			animation.duration = 0.3
			animation.type = kCATransitionFade
			animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
			superView.layer.add(animation, forKey: kCATransitionFade)
		}
		
		superView.addSubview(self)
	}
}
