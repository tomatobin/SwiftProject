//
//  DHBackgroundRunnerManager.swift
//  MyTestProject
//
//  Created by iblue on 2020/10/22.
//  Copyright © 2020 iblue. All rights reserved.
//  后台运行管理类：进入后台，开启定时器，播放无声音频；同时开启后台任备

import AVFoundation
import UIKit

class DHBackgroundRunner: NSObject {
    
    static let shared = DHBackgroundRunner()
    
    fileprivate let audioSession = AVAudioSession.sharedInstance()
    
    fileprivate var backgroundAudioPlayer: AVAudioPlayer?
    
    /// 后台持续播放时间
    fileprivate var backgroundDuration = 0
    
    /// 定时器
    fileprivate var timer: Timer?
    
    /// 定时器时间间隔
    fileprivate var timerInterval: TimeInterval = 1
    
    /// 无声音乐名称
    fileprivate var musicFilename: String = "Silence"
    
    /// 无声音乐类型
    fileprivate var musicFiletype: String = "wav"

    // 是否开启后台自动播放无声音乐
    var openRunner = false {
        didSet {
            if self.openRunner {
                self.setupAudioSession()
                self.setupBackgroundAudioPlayer()
            } else {
                if let player = self.backgroundAudioPlayer {
                    if player.isPlaying {
                        player.stop()
                    }
                }
                self.backgroundAudioPlayer = nil
                try? self.audioSession.setActive(false, options: .notifyOthersOnDeactivation)
            }
        }
    }

    override init() {
        super.init()
        setupListener()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupAudioSession() {
        do {
            try audioSession.setCategory(.playback, options: .mixWithOthers)
            try audioSession.setActive(false)
        } catch let error {
            debugPrint("\(type(of: self)):\(error)")
        }
    }

    private func setupBackgroundAudioPlayer() {
        guard let musiceFilePath =  Bundle.main.path(forResource: musicFilename, ofType: musicFiletype) else {
            return
        }
        
        do {
            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: musiceFilePath))
            debugPrint(Bundle.main.path(forResource: musicFilename, ofType: musicFiletype)!)
        } catch let error {
            debugPrint("\(type(of: self)):\(error)")
        }
        
        backgroundAudioPlayer?.numberOfLoops = -1
        backgroundAudioPlayer?.volume = 0.0
        backgroundAudioPlayer?.delegate = self
    }

    private func setupListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotify), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotify), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterruptionNotify(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
    }
}

// MARK: - Notification Process
extension DHBackgroundRunner {
    /// 进入后台: 播放无声音乐
    @objc public func didEnterBackgroundNotify() {
        guard openRunner else {
            return
        }
        
        setupTimer()

        do {
            try audioSession.setActive(true)
        } catch let error {
            debugPrint("\(type(of: self)):\(error))")
        }
        
        backgroundAudioPlayer?.prepareToPlay()
        backgroundAudioPlayer?.play()
    }

    /// 进入前台: 暂停播放音乐
    @objc public func didBecomeActiveNotify() {
        invalidateTimer()
        hintBackgroundDuration()
        backgroundDuration = 0
        guard openRunner else {
            return
        }

        backgroundAudioPlayer?.pause()
        
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error {
            debugPrint("\(type(of: self)):\(error))")
        }
    }

    /// 音乐中断处理
    @objc fileprivate func audioSessionInterruptionNotify(notification: NSNotification) {
        guard openRunner, let userinfo = notification.userInfo else {
            return
        }
        
        guard let interruptionType: UInt = userinfo[AVAudioSessionInterruptionTypeKey] as! UInt? else {
            return
        }
        
        if interruptionType == AVAudioSession.InterruptionType.began.rawValue {
            // 中断开始，音乐被暂停
            print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder)):: AVAudioSession.InterruptionType.began: \(userinfo)")
        } else if interruptionType == AVAudioSession.InterruptionType.ended.rawValue {
            // 中断结束，恢复播放
            print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder)):: AVAudioSession.InterruptionType.ended.rawValue: \(userinfo)")
            
            guard let player = backgroundAudioPlayer else {
                return
            }
            
            if player.isPlaying == false {
                do {
                    try audioSession.setActive(true)
                } catch let error {
                    debugPrint("\(type(of: self)):\(error)")
                }
                
                player.prepareToPlay()
                player.play()
            }
        }
    }
}

// MARK: - Timer Operation
extension DHBackgroundRunner {
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
    }

    fileprivate func hintBackgroundDuration() {
        print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::Background duration: \(backgroundDuration)s")
    }
}

// MARK: - AVAudioPlayerDelegate
extension DHBackgroundRunner: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder)):: Did finish play.")
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder)):: \(String(describing: error?.localizedDescription))")
    }
}
