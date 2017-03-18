//
//  UIColor+Extension.swift
//  FPSwift
//
//  Created by jiangbin on 16/6/13.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

extension UIColor{
    class func fp_mainBlueColor() -> UIColor {
        return self.fp_colorWithHexString("4EA7F2")!
    }
    
    class func fp_naviBgColor() -> UIColor {
        return self.fp_colorWithHexString("FAFAFA")!
    }
    
    class func fp_mainBgColor() -> UIColor {
        return self.fp_colorWithHexString("EDEDED")!
    }
    
    class func fp_separatorColor() -> UIColor {
        return self.fp_colorWithHexString("EDEDED")!
    }
    
    class func fp_darkBgColor() -> UIColor {
        return self.fp_colorWithHexString("3D3B3E")!
    }
    
    class func fp_darkBlackColor() -> UIColor {
        return self.fp_colorWithHexString("323132")!
    }
    
    class func fp_mainRedColor() -> UIColor {
        return self.fp_colorWithHexString("FF5454")!
    }
    
    class func fp_darkTextColor() -> UIColor {
        return self.fp_colorWithHexString("4A4A4A")!
    }
    
    class func fp_lightTextColor() -> UIColor {
        return self.fp_colorWithHexString("9B9B9B")!
    }
    
    class func fp_yellowColor() -> UIColor {
        return self.fp_colorWithHexString("F3C547")!
    }
    
    class func fp_colorWithHexString(_ hexString: String)->UIColor?{
        let colorString = hexString.replacingOccurrences(of: "#", with: "").uppercased()
        var alpha = CGFloat(0), red = CGFloat(0), green = CGFloat(0), blue = CGFloat(0)
        
        switch colorString.lengthOfBytes(using: String.Encoding.utf8) {
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

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    fileprivate static func fp_colorComponet(_ fromString: String, start: NSInteger, length: NSInteger)->CGFloat{
        let startIndex = fromString.characters.index(fromString.startIndex, offsetBy: start)
        let toIndex = fromString.characters.index(fromString.startIndex, offsetBy: (start + length))
        var subString = fromString.substring(to: toIndex)
        subString = subString.substring(from: startIndex)
        let fullHex = length == 2 ? subString : String(format: "%@%@", subString, subString)
        var hexComponent: UInt32 = 0x0
        Scanner.init(string: fullHex).scanHexInt32(&hexComponent)
        return CGFloat(hexComponent) / 255.0
    }
}
