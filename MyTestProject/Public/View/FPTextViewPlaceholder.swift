//
//  FPTextViewPlaceholder.swift
//  MyTestProject
//
//  Created by jiang_bin on 16/12/27.
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
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
	@objc func textDidChanged() {
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.hasText {
            return
        }
        
        var attrs = Dictionary<NSAttributedStringKey, Any>()
		attrs[NSAttributedStringKey.foregroundColor] = UIColor.lightGray
        if self.font != nil {
			attrs[NSAttributedStringKey.font] = self.font!
        }
        
        self.placeholder?.draw(in: CGRect(x: 5, y: 8, width: self.bounds.width - 5, height: self.bounds.height - 5),
                                     withAttributes: attrs)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
