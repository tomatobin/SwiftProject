//
//  LCPanoTopView.swift
//  LCIphone
//
//  Created by jiangbin on 16/10/19.
//  Copyright © 2016年 dahua. All rights reserved.
//

import UIKit

enum ViewPosition {
    case Left
    case Center
    case Right
}

class LCPanoTopView: UIView {

    /// 固定尺寸
    internal let fixedHeight = CGFloat(30), fixedWith = CGFloat(140)
    private var leftBtn: UIButton!
    private var centerBtn: UIButton!
    private var rightBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUIWidgest()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUIWidgest()
    }
    
    func initUIWidgest() {
        self.layer.cornerRadius = self.fixedHeight / 2.0
        self.layer.borderColor = self.lineColor().CGColor
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
        
        self.leftBtn = self.button(withImage: "live_icon_up", action:#selector(onLeftAction), postion: .Left)
        self.centerBtn = self.button(withImage: "live_icon_up", action:#selector(onCenterAction), postion: .Center)
        self.rightBtn = self.button(withImage: "live_icon_up", action:#selector(onRightAction), postion: .Right)
        
        self.separatorLine(.Left)
        self.separatorLine(.Right)
    }
    
    //MARK: Button State Operation
    func enableButton(postion: ViewPosition) {
        let button = self.getButton(atPostion: postion)
        button.enabled = true
    }
    
    func disableButton(position: ViewPosition) {
        let button = self.getButton(atPostion: position)
        button.enabled = false
    }
    
    /**
     给按钮添加约束
     
     - parameter button:   按钮
     - parameter position: 位置
     */
    func addConstrain(button:UIButton, position: ViewPosition) {
        button.mas_makeConstraints({ make in
            make.height.equalTo()(self.fixedHeight)
            make.width.equalTo()(self.fixedHeight)
            make.centerY.equalTo()(self)
            
            if position == .Center {
                make.centerX.equalTo()(self)
            } else if position == .Left {
                make.left.equalTo()(self).offset()(10)
            } else {
                make.right.equalTo()(self).offset()(-10)
            }
        })
    }
    
    /**
     构建能用按钮样式
     
     - parameter imagename: 图片名称
     - parameter action:    事件处理
     - parameter postion:   按钮位置
     
     - returns: UIButton
     */
    private func button(withImage imagename: String, action: Selector, postion: ViewPosition) -> UIButton {
        let button = UIButton(type: .Custom)
        if let image = UIImage(named: imagename) {
            button.setImage(image, forState: .Normal)
        }
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        self.addSubview(button)
        
        self.addConstrain(button, position: postion)
        return button
    }
    
    /**
     分隔线
     
     - parameter position: 位置，左或右
     
     - returns: UIView
     */
    private func separatorLine(position: ViewPosition) -> UIView {
        let view = UIView()
        view.backgroundColor = self.lineColor()
        self.addSubview(view)
        
        view.mas_makeConstraints({ make in
            make.height.equalTo()(10)
            make.width.equalTo()(0.6)
            make.centerY.equalTo()(self)
            
            if position == .Left {
                make.left.equalTo()(self).offset()(47)
            } else {
                make.right.equalTo()(self).offset()(-47)
            }
        })
        return view
    }
    
    //MARK: Actions
    func onLeftAction() {
        
    }
    
    func onCenterAction() {
        
    }
    
    func onRightAction() {
        
    }
    
    private func lineColor() -> UIColor {
        return UIColor.fp_colorWithHexString("7D7E88")!
    }
    
    /**
     获取对应位置的按钮
     
     - parameter positon: 位置
     
     - returns: 按钮
     */
    private func getButton(atPostion positon: ViewPosition) -> UIButton {
        switch positon {
        case .Left:
            return self.leftBtn
        case .Center:
            return self.centerBtn
        case .Right:
            return self.rightBtn
        }
    }
}
