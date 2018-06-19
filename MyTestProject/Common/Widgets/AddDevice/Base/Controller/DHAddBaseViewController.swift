//
//  DHAddBaseViewController.swift
//  LCIphoneAdhocIP
//
//  Created by iblue on 2018/6/5.
//  Copyright © 2018年 dahua. All rights reserved.
//

import UIKit

class DHAddBaseViewController: FPBaseController,DHAddBaseVCProtocol {
	
	var btnNaviRight: UIButton!
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.title = "Todo::设备添加"
		self.setupNaviRightItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func onLeftNaviItemClick(_ button: UIButton!) {
		let actionType = self.leftActionType()
		if actionType == .back {
			self.navigationController?.popViewController(animated: true)
		} else if actionType == .quit {
			self.exitAddDevice()
		}
	}
	
	func setupNaviRightItem() {
		btnNaviRight = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		btnNaviRight.contentHorizontalAlignment = .right
		btnNaviRight.setImage(UIImage(named: "common_nav_more_n"), for: .normal)
		btnNaviRight.setImage(UIImage(named: "common_nav_more_h"), for: .highlighted)
		btnNaviRight.setImage(UIImage(named: "common_nav_more_h"), for: .disabled)
		btnNaviRight.addTarget(self, action: #selector(onRightAction), for: .touchUpInside)
		let item = UIBarButtonItem(customView: btnNaviRight)
		self.navigationItem.rightBarButtonItems = [item]
		
		btnNaviRight.isHidden = self.isRightActionHidden()
	}
	
	func showQuitAlert(action: (()->())?) {
//		let alert = LCBlockAlertView(title: "Todo:确定退出", message: "你还未完成设备添加，如果退出后，你将重新开始设备添加流程。", cancelButtonTitle: "common_cancel".lc_T, otherButtonTitle: "common_confirm".lc_T) { (_, index) in
//			if index == 1 {
//				action?()
//			}
//		}
//
//		alert?.show()
	}
	
	private func setupRightActionContent() {
//		var otherTitles = [String]()
//		for action in rightActionType() {
//			otherTitles.append(action.title())
//		}
//
//		let sheet = LCSheetView(title: nil, message: nil, delegate: self, cancelButton: "common_cancel".lc_T, otherButtons:otherTitles)
//		sheet?.show()
	}
	
	//MARK: DHAddBaseVCProtocol
	func leftActionType() -> DHAddBaseLeftAction {
		return .back
	}
	
	func rightActionType() -> [DHAddBaseRightAction] {
		return  [.restart]
	}
	
	func isRightActionHidden() -> Bool {
		return false
	}
	
	func enableRightAction(enable: Bool) {
		//btnNaviRight.dh_enable = enable
	}
	
	func isLeftActionShowAlert() -> Bool {
		return false
	}
	
	@objc func onRightAction(button: UIButton) {
		setupRightActionContent()
	}
}

extension DHAddBaseViewController {
//	//MARK: LCSheetViewDelegate
//	func sheetViewCancel(_ sheetView: LCSheetView!) {
//
//	}
//
//	func sheetView(_ sheetView: LCSheetView!, clickedButtonAt buttonIndex: Int) {
//		guard buttonIndex > 0 else {
//			return //0是取消，控件缺陷
//		}
//
//		if let title = sheetView.button(at: buttonIndex).titleLabel?.text {
//			if title == DHAddBaseRightAction.switchToWireless.title() {
//				switchToWirelessVC()
//			} else if title == DHAddBaseRightAction.switchToWired.title() {
//				switchToWiredVC()
//			} else {
//				backToScan()
//			}
//		}
//	}
}

extension DHAddBaseViewController {
	//MARK: Controller Operation
	/// 退出添加流程：返回到进入添加流程的入口界面，需要区分国内、海外
	func exitAddDevice() {
		let action = {
			if let controllers = self.navigationController?.viewControllers {
				for vc in controllers {
					if let cls = NSClassFromString("MMDevicesListViewController"), vc.isKind(of: cls) {
						self.navigationController?.popToViewController(vc, animated: true)
					} else {
						self.navigationController?.popToRootViewController(animated: true)
					}
				}
			} else {
				self.navigationController?.popViewController(animated: true)
			}
		}
		
		
		if isLeftActionShowAlert() {
			showQuitAlert(action: action)
		} else {
			action()
		}
	}
	
	func backToScan() {
		//_ = backToViewController(cls: DHQRScanViewController.classForCoder())
	}
	
	func pushToFAQ() {
//		let controller = DHAddFAQViewController()
//		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	func pushToInitializeSearchVC() {
//		let controller = DHInitializeSearchViewController.storyboardInstance()
//		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	func switchToWiredVC() {
//		//无线切换到有线：跳转插网线引导页
//		DHAddDeviceManager.sharedInstance.netConfigMode = .wired
//		
//		if let vc = backToViewController(cls: DHPowerGuideViewController.self, animated: false) {
//			let controller = DHPlugNetGuideViewController()
//			vc.navigationController?.pushViewController(controller, animated: true)
//		}
	}
	
	func switchToWirelessVC() {
//		//有线切换到无线：当前没有连接WIFI，进入WIFI检查页面；当前已连接WIFI，进入WIFI密码界面
//		DHAddDeviceManager.sharedInstance.netConfigMode = .wifi
//
//		if let vc = backToViewController(cls: DHPowerGuideViewController.self, animated: false) {
//			let controller = DHNetWorkHelper.sharedInstance().emNetworkStatus == .reachableViaWiFi ? DHWifiPasswordViewController.storyboardInstance() : DHWifiCheckViewController()
//			vc.navigationController?.pushViewController(controller, animated: true)
//		}
	}
	
	func stackControllers() -> [UIViewController] {
		var controllers: [UIViewController] = [UIViewController]()
		if let stackControllers = self.navigationController?.viewControllers {
			controllers.append(contentsOf: stackControllers)
		}
		return controllers
	}
	
	private func backToViewController(cls: AnyClass, animated: Bool = true) -> UIViewController? {
		for vc in stackControllers() {
			if vc.classForCoder == cls  {
				self.navigationController?.popToViewController(vc, animated: animated)
				return vc
			}
		}
		
		return nil
	}
}
