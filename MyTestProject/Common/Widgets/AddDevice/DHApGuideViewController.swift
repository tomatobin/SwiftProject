//
//  DHApGuideViewController.swift
//  MyTestProject
//
//  Created by iblue on 2018/6/15.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

struct DHApGuideInfo {
	var imageUrl: String?
	var defaultImageName: String = "adddevice_failhrlp_default"
	var tipText: String = "长按面板按钮10s\n进入AP配置状态"
	var isCheckHidden: Bool = true
	var checkText: String = "已开启设备热点"
	var nextText: String = "下一步"
}

class DHApGuideViewController: DHAddBaseViewController {

	private var guideViews: [DHAddGuideView] = [DHAddGuideView]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	/// 设置引导信息
	public func setup(guides: [DHApGuideInfo]) {
		guideViews.removeAll()
		
		for guideInfo in guides {
			let guideView = DHAddGuideView.xibInstance()
			guideView.delegate = self
			guideView.frame = self.view.bounds
			guideViews.append(guideView)
			
			guideView.topTipLabel.text = guideInfo.tipText
			guideView.topImageView.image = UIImage(named: guideInfo.defaultImageName)
		
			guideView.setCheckHidden(hidden: guideInfo.isCheckHidden)
			guideView.checkButton.setTitle(guideInfo.checkText, for: .normal)
			guideView.nextButton.setTitle(guideInfo.nextText, for: .normal)
		}
		
		resetGuideViewsToFirst()
	}
	
	/// 重置引导图至第一页
	public func resetGuideViewsToFirst() {
		guideViews.forEach { (view) in
			view.removeFromSuperview()
		}
		
		if guideViews.count > 0 {
			self.view.addSubview(guideViews[0])
		}
	}
}

extension DHApGuideViewController: DHAddGuideViewDelegate {
	
	func guideView(view: DHAddGuideView, action: DHAddGuideActionType) {
		guard action == .next else {
			return
		}
		
		let index = guideViews.index(of: view)!
		if index < guideViews.count - 1 {
			// 切换下一页
			let nextView = guideViews[index + 1]
			trans(view: view, toView: nextView)
		} else {
			//最后一步，切到到网络连接
		}
	}
	
	private func trans(view: DHAddGuideView, toView: DHAddGuideView) {
		toView.frame = self.view.bounds
		self.view.addSubview(toView)
		toView.fp_x = FP_SCREEN_WIDTH
		toView.nextButton.alpha = 0
		
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
			view.nextButton.alpha = 0
			toView.nextButton.alpha = 1
			view.fp_x = -FP_SCREEN_WIDTH
			toView.fp_x = 0
		}) { _ in
			view.nextButton.alpha = 1
			view.removeFromSuperview()
		}
	}
}
