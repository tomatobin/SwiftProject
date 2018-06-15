//
//  DHWifiFailureType.swift
//  MyTestProject
//
//  Created by iblue on 2018/6/13.
//  Copyright © 2018年 iblue. All rights reserved.
//

import Foundation

/// 元组定义，按钮与操作类型对应
typealias DHWifiConnectFailureTuple = (button: UIButton, operation: DHWifiConnectFailureOperationType)

/// 按钮操作类型
enum DHWifiConnectFailureOperationType {
	case inputWifiPassword
	case redLightConstantDetail
	case readLightRotateDetail
	case redLightTwinkDetail
	case tryAgain
	case switchToWired
	case complete
}

/// WIFI配置失败类型
enum DHWifiConnectFailureType: String {
	
	case tp1 	= "TP1"
	case tp1s	= "TP1S"
	case g1		= "G1"
	case k5		= "K5"
	case overseasA	= "FamilyA"
	case overseasC	= "FamilyC"
	case overseasDoorbell	= "Doorbell"
	case common	= "DahuaCommon"
	
	func buttonTuples() -> [DHWifiConnectFailureTuple] {
		var buttons: [DHWifiConnectFailureTuple]!
		switch self {
		case .tp1:
			buttons = tp1TypeButtons()
		case .tp1s:
			buttons = tp1sTypeButtons()
		case .g1:
			buttons = g1TypeButtons()
		case .k5:
			buttons = k5TypeButtons()
			
		case .overseasA:
			buttons = overseasATypeButtons()
		case .overseasC:
			buttons = overseasCTypeButtons()
		case .overseasDoorbell:
			buttons = overseasDoorbellButtons()
			
		default:
			buttons = commonTypeButtons()
		}
		return buttons
	}
	
	//MARK: Buttons with type
	private func tp1TypeButtons() -> [DHWifiConnectFailureTuple] {
		let config: [(DHLightButtonType, DHWifiConnectFailureOperationType)] = [(.redTwinkling, .inputWifiPassword),
																				(.redConstant, .redLightConstantDetail), (.greenTwinkling, .inputWifiPassword),
																				(.greenBlueConstant, .complete)]
		return lightButtons(config: config)
	}
	
	private func tp1sTypeButtons() -> [DHWifiConnectFailureTuple] {
		
		let config: [(DHLightButtonType, DHWifiConnectFailureOperationType)] = [(.yellowTwinkling, .inputWifiPassword),
																				(.redRotate, .readLightRotateDetail),
																				(.blueConstant, .complete)]
		return lightButtons(config: config)
	}
	
	private func g1TypeButtons() -> [DHWifiConnectFailureTuple] {
		let config: [(DHLightButtonType, DHWifiConnectFailureOperationType)] = [(.redTwinkling, .redLightTwinkDetail)]
		return lightButtons(config: config)
	}
	
	private func k5TypeButtons() -> [DHWifiConnectFailureTuple] {
		let config: [(String, DHWifiConnectFailureOperationType)] = [("TODO::再试一次", .tryAgain)]
		return commonButtons(config: config)
	}
	
	private func overseasATypeButtons() -> [DHWifiConnectFailureTuple] {
		let config: [(DHLightButtonType, DHWifiConnectFailureOperationType)] = [(.yellowTwinkling, .inputWifiPassword),
																				(.redRotate, .readLightRotateDetail),
																				(.greenTwinkling, .inputWifiPassword),
																				(.blueConstant, .complete)]
		return lightButtons(config: config)
	}
	
	private func overseasCTypeButtons() -> [DHWifiConnectFailureTuple] {
		let config: [(DHLightButtonType, DHWifiConnectFailureOperationType)] = [(.redTwinkling, .inputWifiPassword),
																				(.redConstant, .redLightConstantDetail),
																				(.greenTwinkling, .inputWifiPassword),
																				(.greenConstant, .complete)]
		return lightButtons(config: config)
	}
	
	private func overseasDoorbellButtons() -> [DHWifiConnectFailureTuple] {
		let config: [(String, DHWifiConnectFailureOperationType)] = [("TODO::再试一次", .tryAgain)]
		return commonButtons(config: config)
	}
	
	private func commonTypeButtons() -> [DHWifiConnectFailureTuple] {
		let config: [(String, DHWifiConnectFailureOperationType)] = [("TODO::再试一次", .tryAgain),
																	 ("TODO::TODO::有线添加", .switchToWired)]
		return commonButtons(config: config)
	}
	
	//MARK: General DHLightButton
	private func lightButtons(config : [(type: DHLightButtonType, oper: DHWifiConnectFailureOperationType)]) -> [DHWifiConnectFailureTuple] {
		var tuples = [DHWifiConnectFailureTuple]()
		
		for index in 0..<config.count {
			let button = DHLightButton()
			button.lightType = config[index].type
			tuples.append((button, config[index].oper))
		}
		
		return tuples
	}
	
	//MARK: General CommonButton
	private func commonButtons(config: [(title: String, oper: DHWifiConnectFailureOperationType)]) -> [DHWifiConnectFailureTuple] {
		var tuples = [DHWifiConnectFailureTuple]()
		
		for index in 0..<config.count {
			let button = UIButton(type: .custom)
			button.setTitle(config[index].title, for: .normal)
			tuples.append((button, config[index].oper))
			
			if index == 0 {
				button.setTitleColor(UIColor.white, for: .normal)
				button.backgroundColor = UIColor.lc_colorWithHexString("F67E3C")
				button.layer.masksToBounds = true
			} else {
				button.setTitleColor(UIColor.lc_colorWithHexString("F67E3C"), for: .normal)
				button.backgroundColor = UIColor.white
				button.layer.borderColor = UIColor.gray.cgColor
				button.layer.borderWidth = 0.5
				button.layer.masksToBounds = true
			}
		}
		
		return tuples
		
	}
}
