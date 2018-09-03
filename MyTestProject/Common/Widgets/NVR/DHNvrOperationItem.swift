//
//  DHNvrOperationItem.swift
//  MyTestProject
//
//  Created by iblue on 2018/9/3.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit
import SnapKit

enum DHNvrOperationItemType: String {
	case ignoreAlarm = "Ignore Alarm"
	case talk = "Talk"
	case siren = "Siren"
	
	func getImageTitle() -> (image: String, title: String) {
		switch self {
		case .ignoreAlarm:
			return ("adddevice_light_greenflash", "忽略报警声音")
			
		case .talk:
			return ("adddevice_light_greenalways", "对讲")
			
		default:
			return ("adddevice_light_bluealways", "警迪")
		}
	}
}

class DHNvrOperationItem: UIButton {
	
	var itemType: DHNvrOperationItemType = .ignoreAlarm {
		didSet{
			itemImageView.image = UIImage(named: itemType.getImageTitle().image)
			itemTitleLabel.text = itemType.getImageTitle().title
		}
	}

	var itemImageView: UIImageView!
	var itemTitleLabel: UILabel!

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		itemImageView = UIImageView()
		addSubview(itemImageView)
		
		itemTitleLabel = UILabel()
		itemTitleLabel.textAlignment = .center
		addSubview(itemTitleLabel)
		
		itemImageView.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.bottom.equalTo(self.snp.centerY).offset(-5)
		}
		
		itemTitleLabel.snp.makeConstraints { (make) in
			make.centerX.equalTo(self)
			make.top.equalTo(self.snp.centerY).offset(5)
			make.left.equalTo(self).offset(5)
		}
	}
}
