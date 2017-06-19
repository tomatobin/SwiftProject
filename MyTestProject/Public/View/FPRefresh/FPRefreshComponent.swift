//
//  FPRefreshComponent.swift
//  MyTestProject
//
//  Created by jiangbin on 2017/6/19.
//  Copyright © 2017年 iblue. All rights reserved.
//  刷新控件

import UIKit

class FPRefreshComponent: UIView {

    lazy var loadingView: UIImageView = {
        let image = UIImage(named: "refresh")!
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 10, y: 0, width: image.size.width, height: image.size.height)
        self.addSubview(imageView)
        return imageView
    }()
    
    /// 依赖的外部ScrollView
    weak var scrollView: UIScrollView!
    
    /// ScrollView刚开始时的inset
    var scrollViewOriginalInset: UIEdgeInsets!
    
    /// y方向最大距离
    var yMaxHeight: CGFloat = CGFloat(40)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.placeSubviews()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //避免重复添加
        if let view = self.scrollView, view != newSuperview {
            self.removeObservers()
        }
        
        if newSuperview is UIScrollView {
            
            self.scrollView = newSuperview as! UIScrollView
            self.scrollView.alwaysBounceVertical = true
            
            let contentInset = self.scrollView.contentInset
            self.scrollViewOriginalInset = contentInset
            
            //外部ScrollView设置了contentInset，这里需要同步
            self.fp_y = -contentInset.top - self.bounds.height
            
            //添加KVO
            self.addObservers()
        }
    }
    
    func placeSubviews() {
        self.loadingView.mas_makeConstraints { (make) in
            make!.center.equalTo()(self)
        }
    }
    
    //MARK: KVO
    func addObservers() {
        self.scrollView?.addObserver(self, forKeyPath: FPRefreshPathContentOffset, options: [.new, .old], context: nil)
    }
    
    func removeObservers() {
        self.scrollView?.removeObserver(self, forKeyPath: FPRefreshPathContentOffset)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.isUserInteractionEnabled == false {
            return
        }
        
        if self.isHidden {
            return
        }
        
        if keyPath == FPRefreshPathContentOffset {
            self.scrollViewContentOffsetDidChange(change: change)
        } else if keyPath == FPRefreshPathContentSize {
            self.scrollViewContentSizeDidChange(change: change)
        }
        
    }
    
    func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        let yOffset = self.scrollView.contentOffset.y
        let yDelta = yOffset + self.scrollViewOriginalInset.top
        print("yOffset:\(yOffset), delta:\(yDelta)")
        
        if yDelta > -self.yMaxHeight {
            self.fp_y = yOffset - yDelta - self.bounds.height
        } else {
            self.fp_y = yOffset + self.yMaxHeight
        }
    }
    
    func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
    }
}
