//
//  FPStarsView.swift
//  FPSwift
//
//  Created by iblue on 16/10/16.
//  Copyright © 2016年 iblue. All rights reserved.
//  5星评分控件

import Foundation

class FPStarsView: UIView {
    
    /// 星星数组
    fileprivate var stars = Array<UIImageView>()
    fileprivate var starSize = CGFloat(15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUIWidget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUIWidget()
    }
    
    fileprivate func initUIWidget() {
        let y = (self.bounds.height - self.starSize) / 2.0
        var frame = CGRect(x: 0, y: y, width: self.starSize, height: self.starSize)
        
        let defaultImage = UIImage(named: "star_gray")
        for _ in 0...4 {
            let imageView = UIImageView(image: defaultImage)
            imageView.frame = frame
            self.addSubview(imageView)
            self.stars.append(imageView)
            
            frame = frame.offsetBy(dx: self.starSize + 5, dy: 0)
        }
    }

    /**
     设置评分
     
     - parameter score: 范围0-5
     - parameter animated: 是否动画依次展示
     */
    func setScore(_ score: Int, animated:Bool) {
        var validScore = score
        if score < 0 {
            validScore = 0
        } else if score > 5 {
            validScore = 5
        }
        
        var index = 0
        var delayTime = TimeInterval(0)
        for imageView in self.stars {
            let imagename = index < validScore ? "star_yellow" : "star_gray"
            imageView.image = UIImage(named: imagename)
            
            if animated {
                imageView.alpha = 0
                UIView.animate(withDuration: 0.3, delay: delayTime, options: .curveLinear, animations: {
                    imageView.alpha = 1
                    }, completion: nil)
            }
            
            index += 1
            delayTime += 0.1
        }
    }
}
