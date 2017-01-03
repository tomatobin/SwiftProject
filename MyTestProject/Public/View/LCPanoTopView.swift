//
//  LCPanoTopView.swift
//  LCIphone
//
//  Created by jiangbin on 16/10/19.
//  Copyright © 2016年 dahua. All rights reserved.
//

import UIKit

enum ViewPosition {
    case left
    case center
    case right
}

class LCPanoTopView: UIView {

    /// 固定尺寸
    internal let fixedHeight = CGFloat(30), fixedWith = CGFloat(140)
    fileprivate var leftBtn: UIButton!
    fileprivate var centerBtn: UIButton!
    fileprivate var rightBtn: UIButton!
    
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
        self.layer.borderColor = self.lineColor().cgColor
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
        
        self.leftBtn = self.button(withImage: "live_icon_up", action:#selector(onLeftAction), postion: .left)
        self.centerBtn = self.button(withImage: "live_icon_up", action:#selector(onCenterAction), postion: .center)
        self.rightBtn = self.button(withImage: "live_icon_up", action:#selector(onRightAction), postion: .right)
        
        _ = self.separatorLine(.left)
        _ = self.separatorLine(.right)
    }
    
    //MARK: Button State Operation
    func enableButton(_ postion: ViewPosition) {
        let button = self.getButton(atPostion: postion)
        button.isEnabled = true
    }
    
    func disableButton(_ position: ViewPosition) {
        let button = self.getButton(atPostion: position)
        button.isEnabled = false
    }
    
    /**
     给按钮添加约束
     
     - parameter button:   按钮
     - parameter position: 位置
     */
    func addConstrain(_ button:UIButton, position: ViewPosition) {
        button.mas_makeConstraints({ make in
            make!.height.equalTo()(self.fixedHeight)
            make!.width.equalTo()(self.fixedHeight)
            make!.centerY.equalTo()(self)
            
            if position == .center {
                make!.centerX.equalTo()(self)
            } else if position == .left {
                make!.left.equalTo()(self)!.offset()(10)
            } else {
                make!.right.equalTo()(self)!.offset()(-10)
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
    fileprivate func button(withImage imagename: String, action: Selector, postion: ViewPosition) -> UIButton {
        let button = UIButton(type: .custom)
        if let image = UIImage(named: imagename) {
            button.setImage(image, for: UIControlState())
        }
        button.addTarget(self, action: action, for: .touchUpInside)
        self.addSubview(button)
        
        self.addConstrain(button, position: postion)
        return button
    }
    
    /**
     分隔线
     
     - parameter position: 位置，左或右
     
     - returns: UIView
     */
    fileprivate func separatorLine(_ position: ViewPosition) -> UIView {
        let view = UIView()
        view.backgroundColor = self.lineColor()
        self.addSubview(view)
        
        view.mas_makeConstraints({ make in
            _ = make?.height.equalTo()(10)
            _ = make?.width.equalTo()(0.6)
            _ = make?.centerY.equalTo()(self)
            
            if position == .left {
                _ = make?.left.equalTo()(self)?.offset()(47)
            } else {
                _ = make?.right.equalTo()(self)?.offset()(-47)
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
    
    fileprivate func lineColor() -> UIColor {
        return UIColor.fp_colorWithHexString("7D7E88")!
    }
    
    /**
     获取对应位置的按钮
     
     - parameter positon: 位置
     
     - returns: 按钮
     */
    fileprivate func getButton(atPostion positon: ViewPosition) -> UIButton {
        switch positon {
        case .left:
            return self.leftBtn
        case .center:
            return self.centerBtn
        case .right:
            return self.rightBtn
        }
    }
}
