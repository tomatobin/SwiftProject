//
//  DHBackgroundRunnerPlus.swift
//  MyTestProject
//
//  Created by iblue on 2020/10/23.
//  Copyright © 2020 iblue. All rights reserved.
//  后台运行管理类：进入后台，申请后台任务，根据后台剩余时长，播放无声音乐

import UIKit
import AVFoundation

class DHBackgroundRunnerPlus: NSObject {

    static let shared = DHBackgroundRunnerPlus()
    
    // 是否开启后台自动播放无声音乐
    var openRunner = false {
        didSet {
            
        }
    }
    
    fileprivate let audioSession = AVAudioSession.sharedInstance()
    
    fileprivate var backgroundAudioPlayer: AVAudioPlayer?
    
    /// 后台持续播放时间
    fileprivate var backgroundDuration = 0
    
    /// 定时器
    fileprivate var timer: Timer?
    
    /// 定时器时间间隔
    fileprivate var timerInterval: TimeInterval = 1
    
    var backgroundTask: UIBackgroundTaskIdentifier?
    
    override init() {
        super.init()
        setupTimer()
    }
    
    deinit {
        print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: deinit :)...")
    }
    
    //MARK: - Timer
    fileprivate func setupTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(timerTask), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerTask() {
        backgroundDuration = backgroundDuration + Int(timerInterval)
        let timeRemaining = UIApplication.shared.backgroundTimeRemaining
        if timeRemaining != TimeInterval.greatestFiniteMagnitude {
            print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::Background remains: \(timeRemaining)s")
        }
        
        if timeRemaining < 2 {
            registerBackgroundTask()
        }
    }
    
    fileprivate func hintBackgroundDuration() {
        print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::Background duration: \(backgroundDuration)s")
    }
    
    //MARK: - Background Task
    func registerBackgroundTask() {
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTask != nil {
            UIApplication.shared.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        }
        
        //注册后台任务
        self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            UIApplication.shared.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        })
    }
}
