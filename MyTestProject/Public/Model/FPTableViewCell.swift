//
//  FPTableViewCell.swift
//  FPSwift
//
//  Created by iblue on 16/6/7.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

protocol FPTableViewCellProtocol {
    func configureForCell(item: AnyObject);
}

class FPTableViewCell: UITableViewCell,FPTableViewCellProtocol {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForCell(item: AnyObject) {
        self.textLabel!.text = item as? String
        self.backgroundView = UIView()
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.orangeColor()
        self.selectedBackgroundView = bgView
    }
    
    class func cellIdentifier()->String{
        return "FPTableViewCell"
    }
    
    class func cellHeight()->CGFloat{
        return 44
    }
}
