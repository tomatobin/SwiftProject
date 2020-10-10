//
//  FPNumberKeyboard.swift
//  FPSwift
//
//  Created by iblue on 17/1/6.
//  Copyright © 2017年 iblue. All rights reserved.
//

import UIKit

class FPNumberKeyboard: UIView {
    
    weak var textInput: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func xibInstance() -> FPNumberKeyboard? {
        let view = Bundle.main.loadNibNamed("FPNumberKeyboard", owner: nil, options: nil)?.first
        return view as? FPNumberKeyboard
    }
    
    @IBAction func keyboardViewAction(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1010: //小数点
            if let text = self.textInput?.text {
                if text.count > 0 && text.contains(".") == false  {
                    self.textInput?.insertText(".")
                }
            }
        case 1012: //删除
            if let text = self.textInput?.text {
                if text.count > 0 {
                    self.textInput?.deleteBackward()
                }
            }
        case 1013,1011: //确认
            self.textInput?.resignFirstResponder()
            
        default: //数字
            let number = String(sender.tag - 1000)
            self.textInput?.insertText(number)
        }
    }
}
