//
//  UIButton+CountDown.swift
//  FPSwift
//
//  Created by jiangbin on 16/7/8.
//  Copyright © 2016年 iblue. All rights reserved.
//

extension UIButton{
    func startCount(_ timeLine: Int, title: String, textColor: UIColor) {
        var timeOut = timeLine
        let queue = DispatchQueue.global(qos: .default)
        let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: queue)
        self.alpha = 0.5
        
        //每秒执行一次
        timer.scheduleRepeating(wallDeadline: DispatchWallTime.now(), interval: Double(1))
        timer.setEventHandler(handler: {
            if timeOut <= 0{
                timer.cancel()
                DispatchQueue.main.async(execute: {
                    self.titleLabel?.text = title //这句去掉会实现闪烁的效果
                    self.setTitle(title, for: UIControl.State())
                    self.isUserInteractionEnabled = true
                    self.alpha = 1
                })
            }
            else{
                let seconds = timeOut % 60
                let strTime = String(format: "%d秒后重新获取", seconds)
                DispatchQueue.main.async(execute: {
                    self.titleLabel?.text = strTime
                    self.setTitle(strTime, for: UIControl.State())
                    self.isUserInteractionEnabled = false
                })
                
                timeOut -= 1
            }
        })
        
        timer.resume()
    }
}
