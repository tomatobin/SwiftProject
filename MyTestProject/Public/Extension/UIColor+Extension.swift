//
//  UIColor+Extension.swift
//  FPSwift
//
//  Created by jiangbin on 16/6/13.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

extension UIColor{
    class func fp_colorWithHexString(hexString: String)->UIColor?{
        let colorString = hexString.stringByReplacingOccurrencesOfString("#", withString: "") .uppercaseString
        var alpha = CGFloat?(), red = CGFloat?(), green = CGFloat?(), blue = CGFloat?()
        
        switch colorString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
        case 3: //#RGB
            alpha   = 1.0
            red     = self.fp_colorComponet(colorString, start: 0, length: 1)
            green   = self.fp_colorComponet(colorString, start: 1, length: 1)
            blue    = self.fp_colorComponet(colorString, start: 2, length: 1)
            break
            
        case 4: //#ARGB
            alpha   = self.fp_colorComponet(colorString, start: 0, length: 1)
            red     = self.fp_colorComponet(colorString, start: 1, length: 1)
            green   = self.fp_colorComponet(colorString, start: 2, length: 1)
            blue    = self.fp_colorComponet(colorString, start: 3, length: 1)
            break
            
        case 6: //#RRGGBB
            alpha   = 1.0
            red     = self.fp_colorComponet(colorString, start: 0, length: 2)
            green   = self.fp_colorComponet(colorString, start: 2, length: 2)
            blue    = self.fp_colorComponet(colorString, start: 4, length: 2)
            break
            
        case 8: //#AARRGGBB
            alpha   = self.fp_colorComponet(colorString, start: 0, length: 2)
            red     = self.fp_colorComponet(colorString, start: 2, length: 2)
            green   = self.fp_colorComponet(colorString, start: 4, length: 2)
            blue    = self.fp_colorComponet(colorString, start: 6, length: 2)
            break
            
        default:
            return nil
            
        }

        return UIColor(red: red!, green: green!, blue: blue!, alpha: alpha!)
    }
    
    private static func fp_colorComponet(fromString: String, start: NSInteger, length: NSInteger)->CGFloat{
        let startIndex = fromString.startIndex 
        let toIndex = fromString.startIndex.advancedBy((start + length))
        var subString = fromString.substringToIndex(toIndex)
        subString = subString.substringFromIndex(startIndex)
        let fullHex = length == 2 ? subString : String(format: "%@%@", subString, subString)
        var hexComponent: UInt32 = 0x0
        NSScanner.init(string: fullHex).scanHexInt(&hexComponent)
        return CGFloat(hexComponent) / 255.0
    }
}
