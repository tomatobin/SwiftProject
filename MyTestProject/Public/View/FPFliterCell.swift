//
//  FPFliterCell.swift
//  FPSwift
//
//  Created by iblue on 16/12/20.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

typealias FPFliterCellClick = (_ index: Int) -> Void

class FPFliterCell: UITableViewCell {

    /// 每行默认显示3个
    var numberInLine = Int(3)
    
    /// 选中的序号
    var selectedIndex = Int(0)
    
    var clickBlock: FPFliterCellClick?
    
    /// 左右边距
    var margin = CGFloat(15)
    var space = CGFloat(28)
    
    fileprivate var filterButtons = Array<UIButton>()
    
    class func cellIdentifier() -> String {
        return "FPFliterCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ titles: Array<String>) {
        let btnWidth = (self.bounds.width - 2*margin - CGFloat(numberInLine - 1)*space) / CGFloat(numberInLine)
        let btnHeight = CGFloat(40)
        
        //self.contentView.fp_removeAllSubviews()
        
        if self.filterButtons.count == 0 {
            for index in 0...numberInLine {
                let button = UIButton(type: .custom)
                
                if titles.count > index {
                    button.setTitle(titles[index], for: UIControlState())
                }
                
                button.tag = index
                button.addTarget(self, action: #selector(onButtonAction), for: .touchUpInside)
                self.contentView.addSubview(button)
                self.filterButtons.append(button)
            }
        }
        
        var xOrigin = margin
        for button in self.filterButtons {
            button.frame = CGRect(x: xOrigin, y: CGFloat(5), width: btnWidth, height: btnHeight)
            xOrigin += (btnWidth + space)
            
            if button.tag == selectedIndex {
                button.isSelected = true
            }
            
            self.configButtonStyle(button, selected: button.isSelected)
        }
    }
    
    func configButtonStyle(_ button: UIButton, selected: Bool) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        
        if selected {
            button.layer.borderColor = UIColor.clear.cgColor
            button.backgroundColor = UIColor.fp_yellowColor()
            button.setTitleColor(UIColor.white, for: UIControlState())
        } else{
            button.layer.borderColor = UIColor.fp_separatorColor().cgColor
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.fp_darkTextColor(), for: UIControlState())
        }
    }
    
    func onButtonAction(_ button: UIButton) {
        
        //取消其他按钮的选中状态
        for childButton in self.filterButtons {
            childButton.isSelected = false
            self.configButtonStyle(childButton, selected: false)
        }
        
        button.isSelected = !button.isSelected
        self.configButtonStyle(button, selected: button.isSelected)
        
        if button.tag != self.selectedIndex && self.clickBlock != nil {
            self.clickBlock!(button.tag)
        }
        
        self.selectedIndex = button.tag
    }
}

