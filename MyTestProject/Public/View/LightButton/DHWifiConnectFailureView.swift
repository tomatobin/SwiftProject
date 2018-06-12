//
//  DHWifiConnectFailureView.swift
//  MyTestProject
//
//  Created by iblue on 2018/6/12.
//  Copyright © 2018年 iblue. All rights reserved.
//	WIFI连接超时/失败页面

import UIKit

/// 指示灯
enum DHLightButtonOperationType {
	case inputWifiPassword
	case redLightConstantDetail
	case readLightRotateDetail
	case redLightTwinkDetail
	case tryAgain
	case switchToWired
	case complete
}

/// WIFI配置失败类型
enum DHWifiConnectFailureType {
	case tp1
	case tp1s
	case g1
	case k5
	case overseasA
	case overseasC
	case overseasDoorbell
	case common
}

class DHWifiConnectFailureView: UIView {

	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var scollView: UIScrollView!
	
	private var buttonHeight = CGFloat(45)
	private var buttonVerticalSpace = CGFloat(10)
	
	private var buttons = [UIButton]()
	
	private var failureType: DHWifiConnectFailureType = .tp1
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
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
		
		buttons.removeAll()
		if type == .tp1 {
			buttons.append(contentsOf: tp1TypeButtons())
		} else if type == .tp1s {
			buttons.append(contentsOf: tp1sTypeButtons())
		} else if type == .g1 {
			buttons.append(contentsOf: g1TypeButtons())
		} else if type == .overseasA {
			buttons.append(contentsOf: overseasATypeButtons())
		} else if type == .overseasC {
			buttons.append(contentsOf: overseasCTypeButtons())
		}
		
		for button in buttons {
			scollView.addSubview(button)
		}
	}
	
	private func layoutButtons() {
		var y = CGFloat(0)
		let scrollHeight = scollView.bounds.height
		let height = CGFloat(buttons.count) * buttonHeight + CGFloat(buttons.count - 1) * buttonVerticalSpace
		if height > scrollHeight {
			scollView.contentSize = CGSize(width: scollView.bounds.width, height: height)
		} else {
			//居中
			y = (scrollHeight - height) / 2
		}
		
		for button in buttons {
			button.frame = CGRect(x: 0, y: y, width: scollView.bounds.width, height: buttonHeight)
			y = y + buttonVerticalSpace + buttonHeight
		}
	}
	
	@objc private func lightButtonClicked(button: DHLightButton) {
		
	}
	
	@objc private func commonButtonClicked(button: UIButton) {
		
	}
}

extension DHWifiConnectFailureView {
	private func tp1TypeButtons() -> [DHLightButton] {
		let types: [DHLightButtonType] = [.redTwinkling, .redConstant, .greenTwinkling, .greenBlueConstant]
		return lightButtonsWithTypes(types: types)
	}
	
	private func tp1sTypeButtons() -> [DHLightButton] {
		let types: [DHLightButtonType] = [.yellowTwinkling, .redRotate, .blueConstant]
		return lightButtonsWithTypes(types: types)
	}
	
	private func g1TypeButtons() -> [DHLightButton] {
		let types: [DHLightButtonType] = [.redTwinkling,]
		return lightButtonsWithTypes(types: types)
	}
	
	private func overseasATypeButtons() -> [DHLightButton] {
		let types: [DHLightButtonType] = [.yellowTwinkling, .redRotate, .greenTwinkling, .blueConstant]
		return lightButtonsWithTypes(types: types)
	}
	
	private func overseasCTypeButtons() -> [DHLightButton] {
		let types: [DHLightButtonType] = [.redTwinkling, .redConstant, .greenTwinkling, .greenConstant]
		return lightButtonsWithTypes(types: types)
	}
	
	private func lightButtonsWithTypes(types: [DHLightButtonType]) -> [DHLightButton] {
		var buttons = [DHLightButton]()

		for index in 0..<types.count {
			let button = DHLightButton()
			button.lightType = types[index]
			button.addTarget(self, action: #selector(lightButtonClicked), for: .touchUpInside)
			buttons.append(button)
		}
		
		return buttons
	}
}
