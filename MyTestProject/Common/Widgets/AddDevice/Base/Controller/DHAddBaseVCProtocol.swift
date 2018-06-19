//
//  DHAddBaseVCProtocol.swift
//  LCIphoneAdhocIP
//
//  Created by iblue on 2018/6/5.
//  Copyright © 2018年 dahua. All rights reserved.
//

import Foundation

enum DHAddBaseLeftAction {
	case back		//返回上一级
	case backToScan	//返回到扫描界面
	case quit		//退出
}

enum DHAddBaseRightAction: Int {
	case restart				//重新开始
	case switchToWireless		//切换到无线
	case switchToWired			//切换到有线
	case showHelp				//显示帮助页面h5
	
	func title() -> String {
		switch self {
		case .switchToWireless:
			return "切换到WIFI"
		case .switchToWired:
			return "切换到有线"
		case .showHelp:
			return "帮助"
		default:
			return "重新开始"
		}
	}
}

protocol DHAddBaseVCProtocol: NSObjectProtocol {
	
	//MARK: 配置
	/// 返回键点击触发事件类型
	///
	/// - Returns: 事件类型
	func leftActionType() -> DHAddBaseLeftAction
	
	/// 左键返回操作是否需要提示框
	///
	/// - Returns: true/false
	func isLeftActionShowAlert() -> Bool
	
	/// 右键点击触发事件类型
	///
	/// - Returns: [事件类型]
	func rightActionType() -> [DHAddBaseRightAction]
	
	/// 右键是否隐藏
	///
	/// - Returns: true/false
	func isRightActionHidden() -> Bool
	
	/// 是否启用右键
	///
	/// - Parameter enable: true/false
	func enableRightAction(enable: Bool)
	
	//MARK: 事件
	/// 右键点击事件
	///
	/// - Parameter button: UIButton
	func onRightAction(button: UIButton)
}
