//
//  FPRoomGridView.swift
//  MyTestProject
//
//  Created by jiangbin on 16/10/18.
//  Copyright © 2016年 iblue. All rights reserved.
//

class FPRoomGridView: UIView {
    
    /// Room格的信息
    var gridInfo: FPRoomGridInfo!
    private var imageView: UIImageView!
    private var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUIWidgets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUIWidgets()
    }
    
    func initUIWidgets() {
        self.gridInfo = FPRoomGridInfo()
        self.imageView = UIImageView()
        self.textLabel = UILabel()
        self.textLabel.textAlignment = .Center
        self.textLabel.textColor = UIColor.fp_darkTextColor()
        self.textLabel.font = UIFont.systemFontOfSize(11)
        
        self.addSubview(self.imageView)
        self.addSubview(self.textLabel)
        
        self.imageView.frame = self.bounds
        self.imageView.image = self.gridInfo.image()
        
        self.textLabel.frame = self.bounds
        self.textLabel.numberOfLines = gridInfo.gridType == .Room ? 1 : 2
    }
    
    func updateRoomGrid() {
        self.imageView.image = self.gridInfo.image()
        self.textLabel.numberOfLines = gridInfo.gridType == .Room ? 1 : 2
        self.textLabel.text = self.gridInfo.text()
    }
}
