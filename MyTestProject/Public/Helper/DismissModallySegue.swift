//
//  DismissModallySegue.swift
//  FPSwift
//
//  Created by iblue on 17/1/20.
//  Copyright © 2017年 iblue. All rights reserved.
//  从上往下模态消失效果

import UIKit

class DismissModallySegue: UIStoryboardSegue {

    override func perform() {
        // Assign the source and destination views to local variables.
        let firstVCView = self.source.view
        let secondVCView = self.destination.view
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview(secondVCView!)
        window?.addSubview(firstVCView!)
        secondVCView?.frame = CGRect(x: 0, y: 0, width: FP_SCREEN_WIDTH, height: FP_SCREEN_HEIGHT)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
             firstVCView?.frame = (firstVCView?.frame.offsetBy(dx: 0.0, dy: FP_SCREEN_HEIGHT))!
        }) { (finished: Bool) -> Void in
            firstVCView?.removeFromSuperview() //以免旧的覆盖
            _ = self.source.navigationController?.popViewController(animated: false)
        }
    }
}
