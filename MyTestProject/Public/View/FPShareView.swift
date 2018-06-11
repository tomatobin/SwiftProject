//
//  FPShareView.swift
//  FPSwift
//
//  Created by iblue on 16/11/2.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit


fileprivate let FP_SHARE_URL: String = "https://itunes.apple.com/us/app/%e5%92%8c%e5%b1%85/id1210301903?l=zh&ls=1&mt=8"
//fileprivate let FP_SHARE_URL: String = "https://www.pgyer.com/heju"

/**
 分享类型：可以用Tag值来标记
 
 - WeChat:        微信
 - WeChatFriends: 朋友圈
 - Weibo:         微博
 - QQZone:        QQ空间
 */
enum FPShareType: Int {
    case weChat
    case weChatFriends
    case weibo
    case qqZone
}

class FPShareView: UIView {

    fileprivate var maskControl: UIControl!
    fileprivate var shareItemView: UIView!
    fileprivate var itemHeight = CGFloat(100)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUIWidgets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUIWidgets()
    }
    
    deinit {
        fp_testDeinit(self)
    }
    
    func initUIWidgets() {
        self.backgroundColor = UIColor.clear
        self.isExclusiveTouch = true
        
        //Transparent view
        self.maskControl = UIControl()
        self.maskControl.backgroundColor = UIColor.black
        self.maskControl.alpha = 0.3
        self.maskControl.addTarget(self, action: #selector(tappedBackground), for: .touchUpInside)
        self.addSubview(self.maskControl)

        //Share Items
        let view = Bundle.main.loadNibNamed("FPShareItems", owner: self, options: nil)!.last
        self.shareItemView = view as! UIView
        self.shareItemView.layer.shadowColor = UIColor.black.cgColor
        self.shareItemView.layer.shadowOpacity = 0.3
        self.shareItemView.layer.shadowOffset =  CGSize(width: 0, height: -1)
        self.addSubview(self.shareItemView)
        
        self.maskControl.snp.makeConstraints({make in
            make.edges.equalTo(self)
        })
        
        self.shareItemView.snp.makeConstraints({ make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(self.itemHeight)
        })
    }
    
	@objc func tappedBackground() {
        self.dismiss()
    }
    
    //MARK: Show & Hide
    func show() {
        if let keyWindow = UIApplication.shared.windows.first {
            self.bounds = keyWindow.bounds
            keyWindow.addSubview(self)
            self.showAnimated()
        }
    }
    
    func show(onView superView: UIView) {
        superView.addSubview(self)
        self.showAnimated()
    }
    
    fileprivate func showAnimated() {
        var center = self.shareItemView.center
        center.y = self.bounds.height + self.itemHeight / 2.0
        self.shareItemView.center = center
        center.y = self.bounds.height - self.itemHeight / 2.0
        self.maskControl.alpha = 0.0;
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.shareItemView.center = center
            self.maskControl.alpha = 0.3
            }, completion: { _ in
        })
    }
    
    func dismiss() {
        var center = self.shareItemView.center
        center.y = self.bounds.height + self.itemHeight / 2.0
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.shareItemView.center = center
            self.maskControl.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
        })
    }
    
    //MARK: Share
    @IBAction func onShareClick(_ button: UIButton) {
        let shareType = FPShareType(rawValue: button.tag)
        var platform: SSDKPlatformType = .subTypeWechatSession
        if shareType == .weChat {
            platform = .subTypeWechatSession
            if !WXApi.isWXAppInstalled() {
                _ = FPHudUtility.showMessage("未安装微信客户端")
                return
            }
        } else if shareType == .weChatFriends {
            platform = .subTypeWechatTimeline
            if !WXApi.isWXAppInstalled() {
                _ = FPHudUtility.showMessage("未安装微信客户端")
                return
            }
        } else if shareType == .weibo {
            platform = .typeSinaWeibo
            if !WeiboSDK.isWeiboAppInstalled() {
                _ = FPHudUtility.showMessage("未安装微博客户端")
                return
            }
        } else {
            platform = .subTypeQZone
            if !QQApiInterface.isQQInstalled() {
                _ = FPHudUtility.showMessage("未安装QQ客户端")
                return
            }
        }
        
        self.share(platform)
    }
    
    fileprivate func share(_ platform: SSDKPlatformType) {
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkEnableUseClientShare()
        shareParames.ssdkSetupShareParams(byText: "和居，您身边的选房专家",
                                                images : UIImage(named: "login_logo"),
                                                url : URL(string: FP_SHARE_URL),
                                                title : "和居",
                                                type : SSDKContentType.auto)
        
        //2.进行分享
        ShareSDK.share(platform, parameters: shareParames, onStateChanged: { (state, userData, contentEntity, error) in
            self.dismiss()
            switch state{
            case SSDKResponseState.success:
                _ = FPHudUtility.showMessage("分享成功")
            case SSDKResponseState.fail:
                ColorLog.red("ShareSDK::\(String(describing: error))")
                _ = FPHudUtility.showMessage("分享失败")
            case SSDKResponseState.cancel:
                _ = FPHudUtility.showMessage("分享取消")
                
            default:
                break
            }
        })
    }
}
