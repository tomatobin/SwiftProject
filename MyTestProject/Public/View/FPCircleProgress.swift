//
//  FPCircleProgress.swift
//  FPSwift
//
//  Created by jiangbin on 17/3/17.
//  Copyright © 2017年 iblue. All rights reserved.
//  圆形倒计时视图，广告控件可用

import UIKit

protocol FPCircleProgressDelegate: NSObjectProtocol {
    
    /// 倒计时结束
    ///
    /// - Parameter progress: FPCircleProgress
    func circleProgressCountDownEnd(circleProgress: FPCircleProgress)
    
    /// 点击控件
    ///
    /// - Parameter circleProgress: FPCircleProgress
    func circleProgressClick(circleProgress: FPCircleProgress)
}

class FPCircleProgress: UIView {

    /// 圆环中间颜色
    var centerColor: UIColor = UIColor.black
    
    /// 圆环背景色
    var arcBgColor: UIColor = UIColor.gray
    
    /// 圆环颜色
    var arcUnfinishColor: UIColor = UIColor.orange
    
    /// 代理
    weak var delegate: FPCircleProgressDelegate?
    
    /// 进度
    var percent: Double = 0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    /// 圆环宽度
    var arcWidth: CGFloat = 3
    
    /// 倒计时
    var countSeconds: Double = 5
    
    /// 中间的文字，如“跳过”
    var centerText: String = "跳过"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setupTextLabel()
        self.startCountDown()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        self.setupTextLabel()
        self.startCountDown()
    }
    
    func setupTextLabel() {
        if self.centerText.characters.count > 0 {
            let label = UILabel(frame: self.bounds)
            label.text = self.centerText
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            self.addSubview(label)
        }
    }
    
    func startCountDown() {
        if self.countSeconds <= 0 {
            print("FPCircleProgress::Count down seconds is zeor!")
            return
        }
        
        let queue = DispatchQueue.global(qos: .default)
        let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: queue)
        self.alpha = 0.5
        
        //每0.1秒执行一次
        var timeout = self.countSeconds
        timer.scheduleRepeating(wallDeadline: DispatchWallTime.now(), interval: Double(0.1))
        timer.setEventHandler(handler: {
            if timeout <= 0 {
                timer.cancel()
                
                DispatchQueue.main.async(execute: {
                    print("FPCircleProgress::Count down end...")
                    self.delegate?.circleProgressCountDownEnd(circleProgress: self)
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.percent = self.percent + 0.1 / self.countSeconds
                    //print("FPCircleProgress::Count down \(self.percent)")
                })
                
                timeout = timeout - 0.1
            }
        })
        
        timer.resume()
    }
    
    //MARK: 绘图
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawArcBackground()
        self.drawArc()
        self.drawArcCenter()
        //self.drawText()
    }
    
    /// 画圆环背景色
    func drawArcBackground() {
        let radius = self.bounds.width / 2.0
        self.drawArc(withColor: self.arcBgColor, startAngle: 0, endAngle: CGFloat(2*Double.pi), radius: radius)
    }
    
    /// 画圆环
    func drawArc() {
        if self.percent < 0 || self.percent > 1 {
            return
        }
        
        let radius = self.bounds.width / 2.0
        let endAngle = 2.0 * Double.pi * Double(self.percent) - Double.pi/2.0
        self.drawArc(withColor: self.arcUnfinishColor, startAngle: -(CGFloat)(Double.pi/2.0), endAngle: CGFloat(endAngle), radius: radius)
    }
    
    /// 画圆环前景色
    func drawArcCenter() {
        let radius = self.bounds.width / 2.0 - self.arcWidth
        self.drawArc(withColor: self.centerColor, startAngle: 0, endAngle: CGFloat(2*Double.pi), radius: radius)
    }
    
    func drawText() {
        let text = NSString(string: self.centerText)
        let centerPoint = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
		let attr = [ kCTForegroundColorAttributeName: UIColor.white,
					 kCTFontAttributeName: UIFont.systemFont(ofSize: 13)]
		text.draw(at: centerPoint, withAttributes: attr as [NSAttributedStringKey : Any])
        //text.draw(in: self.bounds, withAttributes: attr)
    }
    
    /// 画圆环
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - startAngle: 开始角度
    ///   - endAngle: 结束角度
    ///   - radius: 半径
    func drawArc(withColor color: UIColor, startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat) {
        let colorRef = color.cgColor
        let centerPoint = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        
        if let contextRef = UIGraphicsGetCurrentContext() {
            contextRef.beginPath()
            contextRef.move(to: centerPoint)
            contextRef.addArc(center: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            contextRef.setFillColor(colorRef)
            contextRef.fillPath()
        }
    }
    
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("FPCircelProgress:: Touches began")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("FPCircelProgress:: Touches end")
        self.delegate?.circleProgressClick(circleProgress: self)
    }
}
