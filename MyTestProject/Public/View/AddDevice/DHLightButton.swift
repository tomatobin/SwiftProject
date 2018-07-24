//
//  DHLightButton.swift
//  LeChangeOverseas
//
//  Created by iblue on 2018/6/12.
//  Copyright © 2018年 Zhejiang bingo Technology Co.,Ltd. All rights reserved.
//	网络连接超时的按钮

import UIKit


enum DHLightButtonType {
	case redConstant
	case redRotate
	case redTwinkling
	case greenConstant
	case greenTwinkling
	case yellowTwinkling
	case blueConstant
	case greenBlueConstant
	
	func animateType() -> DHLightButtonAnimateType {
		var type: DHLightButtonAnimateType = .constant
		switch self {
		case .redTwinkling, .greenTwinkling, .yellowTwinkling:
			type = .twinkling
		
		case .redRotate:
			type = .rotate
			
		default:
			type = .constant
		}
		
		return type
	}
	
	func color() -> UIColor {
		var color = UIColor.orange
		switch self {

		case .greenConstant, .greenTwinkling, .greenBlueConstant:
			color = UIColor.lc_colorWithHexString("34c069")
		
		case .yellowTwinkling:
			color = UIColor.lc_colorWithHexString("ffb700")
			
		case .blueConstant:
			color = UIColor.lc_colorWithHexString("4ea7f2")
		
		default:
			color = UIColor.red //默认红色
		}
		
		return color
	}
	
	func imageNameAndTitle() -> (imageName: String, title: String) {
		switch self {
		case .redTwinkling:
			return ("adddevice_light_redflash", "红灯闪烁")
		case .redRotate:
			return ("adddevice_light_redflash", "红灯旋转")
			
		case .greenConstant:
			return ("adddevice_light_greenalways", "绿灯常亮")
		case .greenTwinkling:
			return ("adddevice_light_greenflash", "绿灯闪烁")
			
		case .yellowTwinkling:
			return ("adddevice_light_yellowflash", "黄灯闪烁")
			
		case .greenBlueConstant:
			return ("adddevice_light_greenalways", "绿灯/蓝灯常亮")
			
		case .blueConstant:
			return ("adddevice_light_bluealways", "蓝灯常亮")
			
		default:
			return ("adddevice_light_redalways", "红灯常亮")
		}
	}
}

/// 指示灯动画类型
enum DHLightButtonAnimateType {
	case constant	//常亮
	case twinkling	//闪烁
	case rotate		//旋转
}

class DHLightButton: UIButton {

	/// 指示灯类型
	public var lightType: DHLightButtonType = .redConstant {
		didSet{
			layer.borderColor = lightType.color().cgColor
			autoSet()
			startAnimation()
		}
	}
	
	/// 设置灯图片
	public var dotImage: UIImage? {
		didSet{
			dotImageView.image = dotImage
		}
	}
	
	private var dotImageView: UIImageView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubviews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupSubviews()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = bounds.height / 2
	}
	
	func setupSubviews() {
		layer.cornerRadius = bounds.height / 2
		layer.borderColor = lightType.color().cgColor
		layer.borderWidth = 0.5
		layer.masksToBounds = true
		
		setTitleColor(lightType.color(), for: .normal)
		
		dotImageView = UIImageView()
		addSubview(dotImageView)
		
		dotImageView.snp.makeConstraints { make in
			make.left.equalTo(25)
			make.centerY.equalTo(self)
			make.height.width.equalTo(25)
		}
	}
	
	//MARK: Animation
	public func startAnimation() {
		if lightType.animateType() == .twinkling {
			let animation = CABasicAnimation(keyPath: "opacity")
			animation.fromValue = 1
			animation.toValue = 0
			animation.autoreverses = true
			animation.duration = 1
			animation.repeatCount = MAXFLOAT
			animation.isRemovedOnCompletion = false
			animation.fillMode = kCAFillModeForwards
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
			dotImageView.layer.add(animation, forKey: "BreathLight")
		}
	}
	
	public func stopAnimation() {
		dotImageView.layer.removeAllAnimations()
	}
	
	//MARK: AutoSetImage
	public func autoSet() {
		setTitleColor(lightType.color(), for: .normal)
		setTitle(lightType.imageNameAndTitle().title, for: .normal)
		dotImageView.image = UIImage(named: lightType.imageNameAndTitle().imageName)
	}
}
