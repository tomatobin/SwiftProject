//
//  FPTextViewPlaceholder.swift
//  MyTestProject
//
//  Created by 江斌 on 16/12/27.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class FPTextViewPlaceholder: UITextView {

    var placeholder: NSString? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textDidChanged), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textDidChanged() {
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if self.hasText() {
            return
        }
        
        var attrs = Dictionary<String,AnyObject>()
        attrs[NSForegroundColorAttributeName] = UIColor.lightGrayColor()
        if self.font != nil {
            attrs[NSFontAttributeName] = self.font!
        }
        
        self.placeholder?.drawInRect(CGRect(x: 5, y: 5, width: self.bounds.width, height: self.bounds.height), withAttributes: attrs)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
