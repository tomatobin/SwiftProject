//
//  FPFliterCell.swift
//  FPSwift
//
//  Created by iblue on 16/12/20.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

typealias FPFliterCellClick = (index: Int) -> Void

class FPFliterCell: UITableViewCell {

    /// 每行默认显示3个
    var numberInLine = Int(3)
    
    /// 选中的序号
    var selectedIndex = Int(0)
    
    var clickBlock: FPFliterCellClick?
    
    /// 左右边距
    var margin = CGFloat(15)
    var space = CGFloat(28)
    
    private var filterButtons = Array<UIButton>()
    
    class func cellIdentifier() -> String {
        return "FPFliterCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(titles: Array<String>) {
        let btnWidth = (self.bounds.width - 2*margin - CGFloat(numberInLine - 1)*space) / CGFloat(numberInLine)
        let btnHeight = CGFloat(40)
        
        //self.contentView.fp_removeAllSubviews()
        
        if self.filterButtons.count == 0 {
            for index in 0...numberInLine {
                let button = UIButton(type: .Custom)
                
                if titles.count > index {
                    button.setTitle(titles[index], forState: .Normal)
                }
                
                button.tag = index
                button.addTarget(self, action: #selector(onButtonAction), forControlEvents: .TouchUpInside)
                self.contentView.addSubview(button)
                self.filterButtons.append(button)
            }
        }
        
        var xOrigin = margin
        for button in self.filterButtons {
            button.frame = CGRect(x: xOrigin, y: CGFloat(5), width: btnWidth, height: btnHeight)
            xOrigin += (btnWidth + space)
            
            if button.tag == selectedIndex {
                button.selected = true
            }
            
            self.configButtonStyle(button, selected: button.selected)
        }
    }
    
    func configButtonStyle(button: UIButton, selected: Bool) {
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        
        if selected {
            button.layer.borderColor = UIColor.clearColor().CGColor
            button.backgroundColor = UIColor.fp_yellowColor()
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else{
            button.layer.borderColor = UIColor.fp_separatorColor().CGColor
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.fp_darkTextColor(), forState: .Normal)
        }
    }
    
    func onButtonAction(button: UIButton) {
        
        //取消其他按钮的选中状态
        for childButton in self.filterButtons {
            childButton.selected = false
            self.configButtonStyle(childButton, selected: false)
        }
        
        button.selected = !button.selected
        self.configButtonStyle(button, selected: button.selected)
        
        if button.tag != self.selectedIndex && self.clickBlock != nil {
            self.clickBlock!(index: button.tag)
        }
        
        self.selectedIndex = button.tag
    }
}

