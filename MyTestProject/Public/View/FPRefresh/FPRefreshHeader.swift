//
//  FPRefreshHeader.swift
//  MyTestProject
//
//  Created by jiangbin on 2017/6/20.
//  Copyright © 2017年 iblue. All rights reserved.
//

import UIKit

class FPRefreshHeader: FPRefreshComponent {

	@objc override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        
        let yOffset = self.scrollView.contentOffset.y
        
        //相对偏移的值
        let yDelta = yOffset + self.scrollViewOriginalInset.top
        //print("yOffset:\(yOffset), delta:\(yDelta)")
        
        //下拉过程中正在刷新或者下拉距离超过限制，固定位置
        if (self.state == .refreshing && yDelta > -self.yMaxHeight - self.bounds.height) ||
            yDelta < -self.yMaxHeight - self.bounds.height {
            //print("🍎 Set y : \(yOffset + self.yMaxHeight) 🍎")
            self.fp_y = yOffset + self.yMaxHeight
        }
        
        //放大因子，值越大，旋转速度越快
        let factor = Double(1.5)
        let angle = factor * Double(yDelta / self.yMaxHeight + self.bounds.height) * Double.pi
        self.loadingView.transform = CGAffineTransform(rotationAngle: -CGFloat(angle))
        
        if self.scrollView.isDragging {
            if self.state == .idle && yDelta < -self.yMaxHeight - self.bounds.height {
                //转为即将刷新的状态
                self.state = .pulling
                self.fp_y = yOffset - yDelta - self.bounds.height
            } else if self.state == .pulling && yDelta > -self.yMaxHeight - self.bounds.height {
                //转化为普通状态
                self.endRefreshing()
            }
        } else if self.state == .pulling { //即将刷新 && 手松开
            print("🍎 Begin refreshing...🍎")
            self.fp_y = yOffset + self.yMaxHeight
            self.beginRefreshing()
        }
    }
}
