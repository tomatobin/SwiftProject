//
//  LCSetJurisdictionHelper.swift
//  FPSwift
//
//  Created by iblue on 17/1/15.
//  Copyright © 2017年 iblue. All rights reserved.
//  权限处理

import UIKit
import AssetsLibrary
import Photos
import MobileCoreServices

class FPSetAuthorizationHelper: NSObject {
    
    /// 显示跳转权限设置的界面
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - controller: 当前显示的controller
    class func showAuthorization(withTitle title: String, message: String, controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        weak var weakAlert = alert
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { action in
            weakAlert?.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { action in
            let urlString = URL(string: UIApplicationOpenSettingsURLString)
            if urlString != nil && UIApplication.shared.canOpenURL(urlString!) {
                UIApplication.shared.openURL(urlString!)
            }
            
            weakAlert?.dismiss(animated: true, completion: nil)
        }))

        
        controller.present(alert, animated: true, completion: nil)
    }
    
    /// 相机权限状态
    ///
    /// - Returns: AVAuthorizationStatus
    class func cameraAuthorizationStatus() -> AVAuthorizationStatus {
        let authorStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        return authorStatus
    }
    
    /// 相册权限状态
    ///
    /// - Returns: PHAuthorizationStatus
    class func photoAuthorizationStatus() -> PHAuthorizationStatus {
        let authorStatus = PHPhotoLibrary.authorizationStatus()
        return authorStatus
    }
}
