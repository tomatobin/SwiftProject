//
//  FPHudUtility.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/19.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage

class FPHudUtility: NSObject,MBProgressHUDDelegate {
    static let sharedInstance: FPHudUtility = FPHudUtility()
    fileprivate var gifHud: MBProgressHUD? //全局只允许显示一个
    fileprivate var progressHud: MBProgressHUD? //当前的进条度hud
    
    fileprivate override init() {
        ColorLog.cyan("FPHudUtility init...")
    }
    
    //MARK: Gif hud
    class func showGifLoading(_ superView: UIView, gifName named: String) -> MBProgressHUD {
        let image = UIImage.sd_animatedGIFNamed(named)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 130)
        if let hud = sharedInstance.gifHud {
            ColorLog.red("Alread has a gif loading hud...")
            hud.customView = imageView
            return hud
        }
        
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud?.mode = .customView
        hud?.color = UIColor.black.withAlphaComponent(0.7)
        hud?.removeFromSuperViewOnHide = true
        hud?.customView = imageView
        //hud.labelText = "努力加载中..."
        hud?.yOffset = Float(-FP_NAVI_HEIGHT)
        hud?.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        sharedInstance.gifHud = hud
        return hud!
    }
    
    class func hideGifLoading() {
        if let hud = sharedInstance.gifHud {
            hud.removeFromSuperview()
            sharedInstance.gifHud = nil
        }
    }
    
    //MARK: Other
    class func showMsg(_ text: String) {
        if let window = UIApplication.shared.delegate?.window {
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud?.labelText = text
            hud?.mode = .text
            hud?.hide(true, afterDelay: 1.5)
        }
    }
    
    class func showWating(_ superView: UIView, text: String, hudMode: MBProgressHUDMode) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud?.delegate = sharedInstance //delegate写法
        hud?.labelText = text
        hud?.mode = hudMode
        sharedInstance.progressHud = hud
        return hud!
    }
    
    class func updateProgressHud(_ progress: Float) {
        if let hud = sharedInstance.progressHud {
            hud.progress = progress
        }
    }
    
    //MARK: Hud delegate
    func hudWasHidden(_ hud: MBProgressHUD!) {
        if self.progressHud == hud {
            self.progressHud = nil
        }
    }
    
}
