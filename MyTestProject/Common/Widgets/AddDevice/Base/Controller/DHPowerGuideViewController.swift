//
//  DHAddGuideViewController.swift
//  LCIphoneAdhocIP
//
//  Created by iblue on 2018/6/5.
//  Copyright © 2018年 bingo. All rights reserved.
//	电源引导页：如果此时搜索到了设备，如果搜索到了设备，直接走有线添加

import UIKit

class DHPowerGuideViewController: DHGuideBaseViewController {
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK: DHAddBaseVCProtocol
	override func rightActionType() -> [DHAddBaseRightAction] {
		return  [.restart]
	}
	
	//MARK: DHGuideBaseVCProtocol
	override func tipText() -> String? {
		return "Todo:请将设备接通电源"
	}
	
	override func tipImageName() -> String? {
		return "adddevice_netsetting_power"
	}
	
	override func isCheckHidden() -> Bool {
		return true
	}
	
	override func isDetailHidden() -> Bool {
		return true
	}
	
	override func nextStepAction() {
//		//局域网搜索到了设备，直接跳转设备初始化搜索界面
//		if DHAddDeviceManager.sharedInstance.isDeviceFindInLocalNetwork() {
//			DHAddDeviceManager.sharedInstance.netConfigMode = .wired
//			pushToInitializeSearchVC()
//			return
//		}
//		
//		let netConfigMode = DHAddDeviceManager.sharedInstance.netConfigMode
//		if netConfigMode == .wired {
//			let plugVc = DHPlugNetGuideViewController()
//			self.navigationController?.pushViewController(plugVc, animated: true)
//			
//		} else if netConfigMode == .wifi {
//			if DHNetWorkHelper.sharedInstance().emNetworkStatus == .reachableViaWiFi {
//				let passwordVc = DHWifiPasswordViewController.storyboardInstance()
//				self.navigationController?.pushViewController(passwordVc, animated: true)
//				
//			} else {
//				let plugVc = DHWifiCheckViewController()
//				self.navigationController?.pushViewController(plugVc, animated: true)
//			}
//		}
	}
}
