//
//  DHAutoKeyboardView.swift
//  LCIphoneAdhocIP
//
//  Created by iblue on 2018/6/4.
//  Copyright © 2018年 dahua. All rights reserved.
//	定义一个参考的view、能根据keyboard能够，自动调整frame的视图
//	如果是约束模式，改变了textField（LCTextField使用了正则表达式的时候，内部会重新设置文字，如果不使用正则表达式就没有问题）的文字，
//	会导致约束textFiled调用布局，导致父视图也重新布局
// 	解决该问题的方法：1、直接更新约束，目前支持top的约束
//				  2、该视图使用frame进行设置，不使用约束

import UIKit

class DHAutoKeyboardView: UIView {
	
	/// 键盘关联的视图
	public var relatedView: UIView?
	
	/// 原始的位置，外层赋值处理，
	public var yOrigin: CGFloat = 0
	
	/// 顶部约束的原始值，外层赋值处理，topConstraint不为空时有效
	public var topConstraintConst: CGFloat = 0
	
	/// 顶部约束，外层赋值处理
	public var topConstraint: NSLayoutConstraint?

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
			
			if distanceToBottom < keyboardFrame.height {
				
				if topConstraint != nil {
					UIView.animate(withDuration: 0.3) {
						self.topConstraint?.constant = distanceToBottom - keyboardFrame.height
						self.superview?.layoutIfNeeded()
						self.layoutIfNeeded()
					}
				} else {
					var frame = self.frame
					frame.origin.y = self.yOrigin + (distanceToBottom - keyboardFrame.height)
					UIView.animate(withDuration: 0.3) {
						self.frame = frame
					}
				}
			}
		}
	}
	
	@objc func keyboardWillHide(notification: Notification) {
		guard relatedView != nil else {
			return
		}

		
		if topConstraint != nil {
			UIView.animate(withDuration: 0.3) {
				self.topConstraint?.constant = self.topConstraintConst
				self.superview?.layoutIfNeeded()
				self.layoutIfNeeded()
			}
			
		} else {
			var frame = self.frame
			
			if frame.origin.y != yOrigin {
				frame.origin.y = yOrigin
				UIView.animate(withDuration: 0.3) {
					self.frame = frame
				}
			}
		}
	}
	
	@objc func tap() {
		self.endEditing(true)
	}
}
