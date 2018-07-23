//
//  DHAutoKeyboardView.swift
//  LCIphoneAdhocIP
//
//  Created by iblue on 2018/6/4.
//  Copyright © 2018年 dahua. All rights reserved.
//	定义一个参考的view、能根据keyboard能够，自动调整frame的视图

import UIKit

class DHAutoKeyboardView: UIView {
	
	/// 键盘关联的视图
	public var relatedView: UIView?
	
	/// 原始的位置，外层赋值处理，
	public var yOrigin: CGFloat = 0

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addObserver()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.addObserver()
		self.addTapGesture()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	func addObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	func addTapGesture() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
		self.addGestureRecognizer(tapGesture)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}

	@objc func keyboardWillShow(notification: Notification) {
		
		guard relatedView != nil else {
			return
		}
		
		if let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
			let keyboardFrame = value.cgRectValue
			let distanceToBottom = self.frame.height - self.relatedView!.frame.maxY
			
			var transform: CGAffineTransform
			if distanceToBottom < keyboardFrame.height {
				transform = CGAffineTransform(translationX: 0, y: distanceToBottom - keyboardFrame.height)
			} else {
				transform = CGAffineTransform.identity
			}
			
			UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
				self.transform = transform
			}, completion: nil)
		}
	}
	
	@objc func keyboardWillHide(notification: Notification) {
		guard relatedView != nil else {
			return
		}
		
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
			self.transform = CGAffineTransform.identity
		}, completion: nil)
	}
	
	@objc func tap() {
		self.endEditing(true)
	}
}
