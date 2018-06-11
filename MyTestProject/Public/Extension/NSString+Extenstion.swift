//
//  NSString+Extenstion.swift
//  FPSwift
//
//  Created by jiangbin on 16/7/8.
//  Copyright © 2016年 iblue. All rights reserved.
//

extension NSString{
    func fp_textSize(_ font: UIFont, size: CGSize) -> CGSize {
        var textSize = CGSize(width: 0, height: 0)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
		let attributes = [kCTFontAttributeName: font, kCTParagraphStyleAttributeName: style]
		textSize = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedStringKey : Any], context: nil).size
        
        return textSize
    }
}
