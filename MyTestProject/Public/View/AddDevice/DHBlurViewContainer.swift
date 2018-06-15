//
//  DHBlurViewContainer.swift
//  MyTestProject
//
//  Created by iblue on 2018/6/14.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class DHBlurViewContainer: UIControl {

	private var contentView: UIView?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubviews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		setupSubviews()
	}
	
	public func show(onView superview: UIView, animated: Bool) {
		guard contentView != nil else {
			return
		}
		
		superview.addSubview(self)
		addSubview(contentView!)
		
		if animated {
			contentView?.fp_y = self.bounds.height
			UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
				self.contentView?.fp_y = self.bounds.height - self.contentView!.fp_height
			}, completion: nil)
		}
	}
	
	public func dismiss(animated: Bool) {
		if animated {
			UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
				self.contentView?.fp_y = self.bounds.height
			}, completion: { _ in
				self.removeFromSuperview()
			})
		} else {
			removeFromSuperview()
		}
	}
	
	public func setupContent(view: UIView, height: CGFloat) {
		contentView = view
		addSubview(view)
		
		view.frame = CGRect(x: 0, y: self.bounds.height - height, width: self.bounds.width, height: height)
	}
	
	private func setupSubviews() {
		let blurEffect = UIBlurEffect(style: .light)
		let visualEffectView = UIVisualEffectView(effect: blurEffect)
		visualEffectView.frame = self.bounds
		addSubview(visualEffectView)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
		addGestureRecognizer(tap)
	}
	
	@objc private func tapBackground() {
		dismiss(animated: true)
	}
}
