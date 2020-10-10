//
//  FPRefreshComponent.swift
//  MyTestProject
//
//  Created by jiangbin on 2017/6/19.
//  Copyright © 2017年 iblue. All rights reserved.
//  刷新控件

import UIKit

class FPRefreshComponent: UIView {

    /// Loading控件
    internal lazy var loadingView: UIImageView = {
        let image = UIImage(named: "FPRefresh")!
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 10, y: 0, width: image.size.width, height: image.size.height)
        self.addSubview(imageView)
        return imageView
    }()
    
    /// 正在刷新的回调
    var refreshingBlock: FPRefreshComponentRefreshingBlcok?
    
    /// 刷新状态(默认idle)
    var state: FPRefreshState = .idle {
        didSet{
            print("🍎 Set state: \(state)🍎")
        }
    }
    
    /// 依赖的外部ScrollView
    weak var scrollView: UIScrollView!
    
    /// ScrollView刚开始时的inset
    internal var scrollViewOriginalInset: UIEdgeInsets!
    
    /// y方向最大距离
    internal var yMaxHeight: CGFloat = CGFloat(40)
    
    deinit {
        fp_testDeinit(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
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
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        self.removeObservers()
    }
    
    func placeSubviews() {
        self.loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    /// 恢复初始位置
    func backToOriginLocation() {
        self.fp_y = -self.scrollViewOriginalInset.top - self.bounds.height
    }
    
    /// 移动到刷新的位置
    func moveToRefreshLocation() {
        self.fp_y = self.scrollView.contentOffset.y + self.yMaxHeight
    }
    
    //MARK: Refresh
    func beginRefreshing() {
        if self.state == .refreshing {
            return
        }
        
        self.state = .refreshing
        self.startRotateAnimation()
        
        UIView.animate(withDuration: FPRefreshFastAnimationDuration, animations: {
            //主动调用时，先移动到loading的位置
            self.moveToRefreshLocation()
        }, completion: { _ in
            self.executeRefreshingCallback()
        })
    }
    
    func endRefreshing() {
        self.state = .idle
        
        UIView.animate(withDuration: FPRefreshFastAnimationDuration, animations: {
            self.backToOriginLocation()
        }) { _ in
            self.stopRotateAnimation()
        }
    }
}

//MARK: 内部方法
extension FPRefreshComponent {
    
    /// 触发回调
    func executeRefreshingCallback() {
        DispatchQueue.main.async {
            self.refreshingBlock?()
        }
    }
    
    //MARK: Rotate
    func startRotateAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.fromValue =  0
        animation.toValue  = -2 * Double.pi
        animation.duration  = 4 / (2 * Double.pi)
        animation.repeatCount = MAXFLOAT
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.loadingView.layer.add(animation, forKey: "rotate")
    }
    
    func stopRotateAnimation() {
        self.loadingView.layer.removeAllAnimations()
    }
    
    //MARK: KVO
    func addObservers() {
        self.scrollView.addObserver(self, forKeyPath: FPRefreshKeyPathContentOffset, options: [.new, .old], context: nil)
    }
    
    func removeObservers() {
        self.scrollView?.removeObserver(self, forKeyPath: FPRefreshKeyPathContentOffset)
    }
    
    func removeObservers(superView: UIView?) {
        superView?.removeObserver(self, forKeyPath: FPRefreshKeyPathContentOffset)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.isUserInteractionEnabled == false {
            return
        }
        
        if keyPath == FPRefreshKeyPathContentSize {
            self.scrollViewContentSizeDidChange(change: change)
        }
        
        if self.isHidden {
            return
        }
        
        if keyPath == FPRefreshKeyPathContentOffset {
            self.scrollViewContentOffsetDidChange(change: change)
        } else if keyPath == FPRefreshKeyPathContentSize {
            self.scrollViewContentSizeDidChange(change: change)
        }
        
    }
    
    @objc func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
    }
    
     @objc func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
    }
}
