//
//  FPTableViewCell.swift
//  FPSwift
//
//  Created by iblue on 16/6/7.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit
import SnapKit

protocol FPTableViewCellProtocol: NSObjectProtocol {
    func configureForCell(item: AnyObject);
}

/**
 几种常用的列表模型
 
 - Normal:   普通cell，只有标题
 - Switch:   带switch开关的cell
 - SubTitle: 后面带子标题的cell
 - RightImage: 后面为图片的cell
 - Check: 后面为check的cell
 */
enum FPCellType {
    case unknown
    case normal
    case switcher
    case subTitle
    case rightImage
    case check
}

class FPTableViewCellData: NSObject {
    var cellTitle: String?
    var imageName: String?
    var imageUrl: String?
    var detail: String?
    var cellType: FPCellType?
    var state: Bool = Bool(false) //默认为关闭（Switch、Check使用）
    
    init(type: FPCellType) {
        self.cellType = type
    }
    
    init(title: String?, imageName: String?, detail: String?, type: FPCellType){
        self.cellTitle = title
        self.imageName = imageName
        self.detail = detail
        self.cellType = type
    }
}

class FPTableViewCell: UITableViewCell,FPTableViewCellProtocol {

    /// 右边默认的Margin
    var rightMargin = CGFloat(15)
    
    var switchView: UISwitch?
    private var rightLabel: UILabel?
    private var rightImageView: UIImageView?
    private var checkButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForCell(item: AnyObject) {
        
        //通用设置
        self.commonConfigure()
        
        //数据格式校验
        if (item is FPTableViewCellData) == false {
            return
        }
    
        let data = item as! FPTableViewCellData
        self.textLabel?.text = item.cellTitle
        
        self.backgroundView = UIView()
        let bgView = UIView()
        bgView.backgroundColor = UIColor.lightGray
        self.selectedBackgroundView = bgView
        
        //Configure for right label
        if data.cellType == .subTitle {
            self.configureRightLabel(content: data.detail)
        }
        else if data.cellType == .rightImage {
            if let imageName = data.imageName {
                var imageUrl: NSURL?
                if data.imageUrl != nil {
                    imageUrl = NSURL(string: data.imageUrl!)
                }
                self.configureRightImageView(imageName: imageName, imageUrl: imageUrl)
            }
        } else if data.cellType == .switcher {
            self.configureSwitcherCell(on: data.state)
        } else if data.cellType == .check {
            self.configureCheckButton(on: data.state)
        }
    
        if data.imageName == nil {
            self.imageView?.image = nil
        }
        else if data.cellType != .rightImage {
            self.imageView?.image = UIImage(named: data.imageName!)
        }
    }
    
    //MARK: Setting Cell Styles
    func commonConfigure() {
        self.selectionStyle = .none
        self.textLabel?.font = UIFont.systemFont(ofSize: 15)
        self.textLabel?.textColor = UIColor.fp_darkTextColor()
        
        self.switchView?.removeFromSuperview()
        self.rightLabel?.removeFromSuperview()
        self.rightLabel?.removeFromSuperview()
        self.checkButton?.removeFromSuperview()
        
        self.switchView = nil
        self.rightLabel = nil
        self.rightImageView = nil
        self.checkButton = nil
    }
    
    func configureRightLabel(content: String?) {
        if self.rightLabel == nil {
            let label = UILabel()
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 14)
            label.adjustsFontSizeToFitWidth = true
            label.textColor = UIColor.fp_lightTextColor()
            self.contentView.addSubview(label)
            
            label.snp.makeConstraints{ make in
                make.left.equalTo(self.contentView).offset(80)
                make.right.equalTo(self).offset(-self.rightMargin)
                make.top.bottom.equalTo(self.contentView)
            }
            
            self.rightLabel = label
        }
        
        self.rightLabel?.isHidden = false
        self.rightLabel?.text = content
    }
    
    func configureRightImageView(imageName: String, imageUrl: NSURL?) {
        if self.rightImageView == nil {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            self.contentView.addSubview(imageView)
            self.rightImageView = imageView
            
            imageView.snp.makeConstraints{ make in
                make.right.equalTo(self).offset(-self.rightMargin)
                make.height.width.equalTo(60)
                make.centerY.equalTo(self.contentView)
            }
            
            imageView.layer.cornerRadius = 30
            imageView.layer.masksToBounds = true
        }
        
        if imageUrl != nil {
            self.rightImageView?.sd_setImage(with: imageUrl! as URL, placeholderImage: UIImage(named: imageName))
        } else {
            self.rightImageView?.image = UIImage(named: imageName)
        }
    }
    
    func configureSwitcherCell(on: Bool) {
        if self.switchView == nil {
            let switcher = UISwitch()
            self.contentView.addSubview(switcher)
            self.switchView = switcher
            
            switcher.snp.makeConstraints({make in
                _ = make.right.equalTo(self).offset(-self.rightMargin - 5)
                _ = make.size.equalTo(CGSize(width: 40, height: 30))
                _ = make.centerY.equalTo(self)
            })
        }
        
        self.switchView?.isOn = on
    }
    
    func configureCheckButton(on: Bool) {
        if self.checkButton == nil {
            let button = UIButton(type: .custom)
            button.isUserInteractionEnabled = false //屏蔽内部点击事件，外部didSelectCell中处理
            self.contentView.addSubview(button)
            self.checkButton = button
            
            button.snp.makeConstraints({make in
                make.right.equalTo(self).offset(-self.rightMargin)
                make.size.equalTo(CGSize(width: 23, height: 23))
                make.centerY.equalTo(self)
            })
        }
        
        let imagename = on ? "checkbox_select" : "checkbox_unselect"
        self.checkButton?.setImage(UIImage(named: imagename), for: .normal)
    }
    
    //MARK: Class Methods
    class func cellIdentifier()->String{
        return "FPTableViewCell"
    }
    
    class func cellHeight()->CGFloat{
        return 44.0
    }
}
