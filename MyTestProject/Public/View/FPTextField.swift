//
//  FPTextField.swift
//  FPSwift
//
//  Created by jiangbin on 16/7/13.
//  Copyright © 2016年 iblue. All rights reserved.
//  textfield designed for valid input characters, if you set the delegate and rewrite
//  delegate method, your method will work.don't rewrite 'textField:shouldChangeCharactersInRange:replacementString:' or
//  valid method will not work.

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


typealias FPTextFieldMsgBlock = (_ tipMsg: String) -> Void

class FPTextField: UITextField,UITextFieldDelegate {
    var limitLength: Int = Int(16) //默认限制长度16
    var invalidChars: String?
    var regPattern: String?
    weak var fp_delegate: UITextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup() {
        //self.layoutIfNeeded() iOS为什么有个默认的约束1000
        self.delegate = self
        self.contentVerticalAlignment = .center  //垂直居中
    }
    
    func checkByRegular(_ pattern: String) -> Bool {
        if pattern.characters.count == 0 {
            return true
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self.text)
    }
    
    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let originText = NSString(string: string)
        var newText: NSString = NSString(string: textField.text!)
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        if newText.length == 0 {
            _ = self.fp_delegate!.textField!(self, shouldChangeCharactersIn: range, replacementString: string)
            return true
        }
        
        //长度超出范围
        if newText.length > self.limitLength {
            _ = self.fp_delegate!.textField!(self, shouldChangeCharactersIn: range, replacementString: string)
            return false
        }
        
        //非法输入检验
        if self.invalidChars?.characters.count > 0 {
            let charSet = CharacterSet(charactersIn: self.invalidChars!)
            let range = originText.rangeOfCharacter(from: charSet)
            if range.length != 0 {
                _ = self.fp_delegate!.textField!(self, shouldChangeCharactersIn: range, replacementString: string)
                return false
            }
        }
        
        //正则表达式检验
        if self.regPattern != nil {
            let predicate = NSPredicate(format: "SELF MATCHES %@", self.regPattern!)
            _ = self.fp_delegate!.textField!(self, shouldChangeCharactersIn: range, replacementString: string)
            
            return predicate.evaluate(with: newText)
        }
        
        _ = self.fp_delegate!.textField!(self, shouldChangeCharactersIn: range, replacementString: string)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let theMothod = self.fp_delegate?.textFieldShouldBeginEditing {
            return theMothod(textField)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let theMothod = self.fp_delegate?.textFieldDidBeginEditing {
            theMothod(textField)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let theMothod = self.fp_delegate?.textFieldShouldEndEditing {
            return theMothod(textField)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let theMothod = self.fp_delegate?.textFieldDidEndEditing(_:) {
            theMothod(textField)
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let theMothod = self.fp_delegate?.textFieldShouldClear {
            return theMothod(textField)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let theMothod = self.fp_delegate?.textFieldShouldReturn {
            return theMothod(textField)
        }
        
        return true
    }
    
//    override func respondsToSelector(aSelector: Selector) -> Bool {
//        let selString = NSStringFromSelector(aSelector)
//        if "customOverlayContainer" == selString {
//            return false
//        }
//        
//        return true
//    }
}
