//
//  DHWifiConnectFailureView.swift
//  MyTestProject
//
//  Created by iblue on 2018/6/12.
//  Copyright © 2018年 iblue. All rights reserved.
//	WIFI连接超时/失败页面

import UIKit

class DHWifiConnectFailureView: UIView {

	/// 失败按钮操作类型【注意循环引用的问题】
	public var action: ((DHWifiConnectFailureType, DHWifiConnectFailureOperationType) -> ())?
	
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var scollView: UIScrollView!
	
	private var buttonHeight = CGFloat(45)
	private var buttonVerticalSpace = CGFloat(10)
	
	private var buttonTuples = [DHWifiConnectFailureTuple]()
	
	private var failureType: DHWifiConnectFailureType = .tp1
	
	private var buttonTag = Int(0)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layoutButtons()
	}
	
	public static func xibInstance() -> DHWifiConnectFailureView {
		let view = Bundle.main.loadNibNamed("DHWifiConnectFailureView", owner: nil, options: nil)!.first as! DHWifiConnectFailureView
		return view
	}
	
	public func setFailureType(type: DHWifiConnectFailureType) {
		failureType = type

		buttonTuples.removeAll()
		buttonTuples.append(contentsOf: failureType.buttonTuples())

		var tag = 0
		for tuple in buttonTuples {
			tuple.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
			tuple.button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
			tuple.button.tag = tag
			tag = tag + 1
			scollView.addSubview(tuple.button)
		}
	}

	private func layoutButtons() {
		
		var y = CGFloat(0)
		let scrollHeight = scollView.bounds.height
		let height = CGFloat(buttonTuples.count) * buttonHeight + CGFloat(buttonTuples.count - 1) * buttonVerticalSpace
		if height > scrollHeight {
			scollView.contentSize = CGSize(width: scollView.bounds.width, height: height)
		} else {
			//居中
			y = (scrollHeight - height) / 2
		}
		
		for tuple in buttonTuples {
			tuple.button.frame = CGRect(x: 0, y: y, width: scollView.bounds.width, height: buttonHeight)
			tuple.button.layer.cornerRadius = buttonHeight / 2.0
			y = y + buttonVerticalSpace + buttonHeight
		}
	}
	
	@objc private func buttonClicked(button: UIButton) {
		guard button.tag < buttonTuples.count else {
			return
		}
		
		let tuple = buttonTuples[button.tag]
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: OperationType:\(tuple.operation)")
		action?(failureType, tuple.operation)
	}
}

