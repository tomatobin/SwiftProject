//
//  DHNvrOperationView.swift
//  MyTestProject
//
//  Created by iblue on 2018/9/3.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit
import SnapKit

class DHNvrOperationView: UIView {

	private var items: [DHNvrOperationItem] = [DHNvrOperationItem]()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addBottomLine()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		addBottomLine()
	}
	
	func setup(types: [DHNvrOperationItemType]) {
		items.forEach { (item) in
			item.removeFromSuperview()
		}
		
		let width = bounds.width / 3
		
		for type in types {
			let item = DHNvrOperationItem()
			item.itemType = type
			item.addTarget(self, action: #selector(onItemAction(item:)), for: .touchUpInside)
			items.append(item)
			addSubview(item)
		}
		
		//【*】只有一个选项时，居中显示
		//【*】大于一个时，从左到右排列
		if items.count == 1 {
			items.first!.snp.makeConstraints { (make) in
				make.width.equalTo(width)
				make.center.height.equalTo(self)
			}
		} else {
			for index in 0..<items.count {
				let item = items[index]
				item.snp.makeConstraints { (make) in
					make.left.equalTo(width * CGFloat(index))
					make.width.equalTo(width)
					make.top.height.equalTo(self)
				}
			}
		}
	}
	
	func getItem(type: DHNvrOperationItemType) -> DHNvrOperationItem? {
		for item in items {
			if item.itemType == type {
				return item
			}
		}
		
		return nil
	}
	
	func addCornerRadius(radius: CGFloat) {
		let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = bounds
		maskLayer.path = maskPath.cgPath
		layer.mask = maskLayer
	}
	
	//MARK: Private
	@objc func onItemAction(item: DHNvrOperationItem) {
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: Click \(item.itemType.rawValue)")
	}
	
	private func addBottomLine() {
		let line = UIView()
		line.backgroundColor = UIColor.groupTableViewBackground
		addSubview(line)
		
		line.snp.makeConstraints { (make) in
			make.height.equalTo(0.5)
			make.left.width.equalTo(self)
			make.bottom.equalTo(self).offset(-0.5)
		}
	}
}
