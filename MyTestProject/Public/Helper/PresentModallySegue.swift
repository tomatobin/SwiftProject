//
//  PresentModallySegue.swift
//  FPSwift
//
//  Created by iblue on 17/1/20.
//  Copyright © 2017年 iblue. All rights reserved.
//  从下往上模态弹出效果

import UIKit

class PresentModallySegue: UIStoryboardSegue {

    override func perform() {
        let firstVCView = self.source.view
        let secondVCView = self.destination.view
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        secondVCView?.frame = CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: screenHeight)
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView!, aboveSubview: firstVCView!)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            secondVCView?.frame = (secondVCView?.frame.offsetBy(dx: 0.0, dy: -screenHeight))!
        }) { (finished: Bool) -> Void in
            self.source.navigationController?.pushViewController(self.destination, animated: false)
        }
    }
}
