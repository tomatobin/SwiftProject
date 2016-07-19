//
//  FPHudUtility.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/19.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class FPHudUtility: NSObject,MBProgressHUDDelegate {
    static let sharedInstance: FPHudUtility = FPHudUtility()
    private var gifHud: MBProgressHUD? //全局只允许显示一个
    private var progressHud: MBProgressHUD? //当前的进条度hud
    
    private override init() {
        ColorLog.cyan("FPHudUtility init...")
    }
    
    //MARK: Gif hud
    class func showGifLoading(superView: UIView, gifName named: String) -> MBProgressHUD {
        let image = UIImage.sd_animatedGIFNamed(named)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 130)
        if let hud = sharedInstance.gifHud {
            ColorLog.red("Alread has a gif loading hud...")
            hud.customView = imageView
            return hud
        }
        
        let hud = MBProgressHUD.showHUDAddedTo(superView, animated: true)
        hud.mode = .CustomView
        hud.color = UIColor.blackColor().colorWithAlphaComponent(0.7)
        hud.removeFromSuperViewOnHide = true
        hud.customView = imageView
        //hud.labelText = "努力加载中..."
        hud.yOffset = Float(-FP_NAVI_HEIGHT)
        hud.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        sharedInstance.gifHud = hud
        return hud
    }
    
    class func hideGifLoading() {
        if let hud = sharedInstance.gifHud {
            hud.removeFromSuperview()
            sharedInstance.gifHud = nil
        }
    }
    
    //MARK: Other
    class func showMsg(text: String) {
        if let window = UIApplication.sharedApplication().delegate?.window {
            let hud = MBProgressHUD.showHUDAddedTo(window, animated: true)
            hud.labelText = text
            hud.mode = .Text
            hud.hide(true, afterDelay: 1.5)
        }
    }
    
    class func showWating(superView: UIView, text: String, hudMode: MBProgressHUDMode) -> MBProgressHUD {
        let hud = MBProgressHUD.showHUDAddedTo(superView, animated: true)
        hud.delegate = sharedInstance //delegate写法
        hud.labelText = text
        hud.mode = hudMode
        sharedInstance.progressHud = hud
        return hud
    }
    
    class func updateProgressHud(progress: Float) {
        if let hud = sharedInstance.progressHud {
            hud.progress = progress
        }
    }
    
    //MARK: Hud delegate
    func hudWasHidden(hud: MBProgressHUD!) {
        if self.progressHud == hud {
            self.progressHud = nil
        }
    }
    
}
