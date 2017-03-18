//
//  FPHudUtility.swift
//  FPSwift
//
//  Created by iblue on 16/7/18.
//  Copyright © 2016年 iblue. All rights reserved.
//  Hud层封装，初步调用了MBProgressHUD，后期可能会添加其他Hud

import UIKit
import MBProgressHUD
import SDWebImage

class FPHudUtility: NSObject {
    static let sharedInstance: FPHudUtility = FPHudUtility()
    fileprivate var gifHud: MBProgressHUD? //全局只允许显示一个
    fileprivate var progressHud: MBProgressHUD? //当前的进条度hud

    class func showGifLoading(_ superView: UIView, gifName named: String) -> MBProgressHUD {
        let image = UIImage.sd_animatedGIFNamed(named)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        
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
        //hud.yOffset = Float(-FP_NAVI_HEIGHT)
        sharedInstance.gifHud = hud
        return hud!
    }
    
    class func showMessage(_ message: String) -> MBProgressHUD {
        let keyWindow = UIApplication.shared.windows.first
        let hud = MBProgressHUD.showAdded(to: keyWindow, animated: true)
        hud?.mode = .text
        hud?.color = UIColor.black.withAlphaComponent(0.7)
        hud?.removeFromSuperViewOnHide = true
        hud?.detailsLabelFont = UIFont.systemFont(ofSize: 16)
        hud?.detailsLabelText = message
        hud?.hide(true, afterDelay: 1.5)
        return hud!
    }
    
    class func hideGifLoading() {
        if let hud = sharedInstance.gifHud {
            hud.removeFromSuperview()
            sharedInstance.gifHud = nil
        }
    }
    
    class func showWaitingHud(_ superView: UIView) -> MBProgressHUD {
        MBProgressHUD.hideAllHUDs(for: superView, animated: true)
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud?.color = UIColor.black.withAlphaComponent(0.7)
        return hud!
    }
    
    class func hideHuds(_ superView: UIView) {
        MBProgressHUD.hideAllHUDs(for: superView, animated: true)
    }
    
    fileprivate override init() {
        ColorLog.cyan("FPHudUtility init...")
    }
    
    class func updateProgressHud(_ progress: Float) {
        if let hud = FPHudUtility.sharedInstance.progressHud {
            hud.progress = progress
        }
    }
}
