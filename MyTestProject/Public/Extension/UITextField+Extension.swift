//
//  UITextField+Extension.swift
//  FPSwift
//
//  Created by jiangbin on 16/7/7.
//  Copyright © 2016年 iblue. All rights reserved.
//

extension UITextField{
    func fp_setLeftImageView(_ imageName: String) {
        let leftSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftSize - 5, height: leftSize))
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.center = leftView.center
        leftView.addSubview(imageView)
        self.leftView = leftView
        self.leftViewMode = .always
    }
    
    func fp_setRightView(_ customView: UIView) {
        let height = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let maxSize = CGFloat(100)
        let radius = self.bounds.height / 2.0
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: maxSize, height: height))
        customView.contentMode = .right
        rightView.addSubview(customView)
        
        //调整customView位置，y方向居中，x方向靠右(并向右偏移5)
        let x = maxSize - customView.bounds.width - radius + 5
        let y = (self.bounds.height - customView.bounds.height) / 2.0
        customView.frame.origin = CGPoint(x: x, y: y)
        
        self.rightView = rightView
        self.rightViewMode = .always
    }
}
