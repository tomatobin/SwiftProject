//
//  FPWKWebController.swift
//  FPSwift
//
//  Created by iblue on 17/1/8.
//  Copyright © 2017年 iblue. All rights reserved.
//  WKWebView加载H5页面

import UIKit
import WebKit

class FPWKWebController: FPBaseController,WKUIDelegate,WKNavigationDelegate {
    
    /// 加载的URL
    var requestUrl: String?
    
    var webView: WKWebView!
    
    var progressView: UIProgressView!
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func initNaviLeftItemFromImage() -> String? {
        return "back"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        
        //Config WebView
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.preferences.javaScriptEnabled = true
        
        let frame = CGRect(x: 0, y: FP_NAVI_HEIGHT, width: self.view.bounds.width, height: self.view.bounds.height - FP_NAVI_HEIGHT)
        webView = WKWebView(frame: frame, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        self.view.addSubview(webView)
        
        //Config ProgressView
        progressView = UIProgressView(frame: CGRect(x: 0, y: FP_NAVI_HEIGHT, width: self.view.bounds.width, height: 1))
        progressView.tintColor = UIColor.fp_yellowColor()
        progressView.trackTintColor = UIColor.white
        self.view.addSubview(progressView)
            
        //Add KVO
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.loadWebView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 加载WebView
    func loadWebView() {
        if self.requestUrl?.characters.count == 0 || self.requestUrl == nil {
            return
        }
        
        if let url = URL(string: self.requestUrl!) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    //MARK: KVO For Progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progress = Float(self.webView.estimatedProgress)
            self.progressView.setProgress(progress, animated: true)
            if progress >= 1.0 {
                
                UIView.animate(withDuration: 0.25, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.transform = CGAffineTransform(scaleX: 1.0, y: 1.25)
                }, completion: { finish in
                    self.progressView.progress = 0
                    self.progressView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
        } else if keyPath == "title" {
            self.navigationItem.title = webView.title
        }
    }
    
    //MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ColorLog.green("\(NSStringFromClass(self.classForCoder))::Start load url \(String(describing: webView.url?.absoluteString))")
        self.progressView.progress = 0
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ColorLog.green("\(NSStringFromClass(self.classForCoder))::Load failed....")
        self.progressView.progress = 0
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ColorLog.green("\(NSStringFromClass(self.classForCoder))::Load failed....")
        self.progressView.progress = 0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ColorLog.green("\(NSStringFromClass(self.classForCoder))::Load finished....")
    }
}

