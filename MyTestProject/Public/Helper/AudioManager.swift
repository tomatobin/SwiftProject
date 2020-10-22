//
//  DHBackgroundRunnerManager.swift
//  MyTestProject
//
//  Created by iblue on 2020/10/22.
//  Copyright © 2020 iblue. All rights reserved.
//  后台运行管理类

import AVFoundation
import UIKit

class DHBackgroundRunnerManager: NSObject {
    
    static let shared = DHBackgroundRunnerManager()
    
    fileprivate let audioSession = AVAudioSession.sharedInstance()
    
    fileprivate var backgroundAudioPlayer: AVAudioPlayer?
    
    fileprivate var backgroundTimeLength = 0
    
    fileprivate var timer: Timer?
    
    fileprivate var musicFilename: String = "Silence"
    
    fileprivate var musicFiletype: String = "wav"

    // 是否开启后台自动播放无声音乐
    var openBackgroundAudioAutoPlay = false {
        didSet {
            if self.openBackgroundAudioAutoPlay {
                self.setupAudioSession()
                self.setupBackgroundAudioPlayer()
            } else {
                if let player = self.backgroundAudioPlayer {
                    if player.isPlaying {
                        player.stop()
                    }
                }
                self.backgroundAudioPlayer = nil
                try? self.audioSession.setActive(false, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
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
            try audioSession.setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
            try audioSession.setActive(false)
        } catch let error {
            debugPrint("\(type(of: self)):\(error)")
        }
    }

    private func setupBackgroundAudioPlayer() {
        do {
            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: musicFilename, ofType: musicFiletype)!))
            debugPrint(Bundle.main.path(forResource: musicFilename, ofType: musicFiletype)!)
        } catch let error {
            debugPrint("\(type(of: self)):\(error)")
        }
        backgroundAudioPlayer?.numberOfLoops = -1
        backgroundAudioPlayer?.volume = 0.0
        backgroundAudioPlayer?.delegate = self
    }

    private func setupListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
    }
}

// MARK: - 扩展 监听通知

extension DHBackgroundRunnerManager {
    /// 进入后台 播放无声音乐
    @objc public func didEnterBackground() {
        setupTimer()
        
        guard openBackgroundAudioAutoPlay else {
            return
        }

        do {
            try audioSession.setActive(true)
        } catch let error {
            debugPrint("\(type(of: self)):\(error))")
        }
        
        backgroundAudioPlayer?.prepareToPlay()
        backgroundAudioPlayer?.play()
    }

    /// 进入前台，暂停播放音乐
    @objc public func didBecomeActive() {
        removeTimer()
        hintBackgroundTimeLength()
        backgroundTimeLength = 0
        guard openBackgroundAudioAutoPlay else {
            return
        }

        backgroundAudioPlayer?.pause()
        
        do {
            try audioSession.setActive(false, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        } catch let error {
            debugPrint("\(type(of: self)):\(error))")
        }
    }

    /// 音乐中断处理
    @objc fileprivate func audioSessionInterruption(notification: NSNotification) {
        guard openBackgroundAudioAutoPlay, let userinfo = notification.userInfo else {
            return
        }
        
        guard let interruptionType: UInt = userinfo[AVAudioSessionInterruptionTypeKey] as! UInt? else {
            return
        }
        
        if interruptionType == AVAudioSession.InterruptionType.began.rawValue {
            // 中断开始，音乐被暂停
            debugPrint("\(type(of: self)): 中断开始 userinfo:\(userinfo)")
        } else if interruptionType == AVAudioSession.InterruptionType.ended.rawValue {
            // 中断结束，恢复播放
            debugPrint("\(type(of: self)): 中断结束 userinfo:\(userinfo)")
            guard let player = backgroundAudioPlayer else { return }
            if player.isPlaying == false {
                debugPrint("\(type(of: self)): 音乐未播放，准备开始播放")
                do {
                    try audioSession.setActive(true)
                } catch let error {
                    debugPrint("\(type(of: self)):\(error)")
                }
                player.prepareToPlay()
                player.play()
            } else {
                debugPrint("\(type(of: self)): 音乐正在播放")
            }
        }
    }
}

// MARK: - 扩展 定时器任务
extension DHBackgroundRunnerManager {
    fileprivate func setupTimer() {
        removeTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTask), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }

    fileprivate func removeTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc func timerTask() {
        backgroundTimeLength += 1
    }

    fileprivate func hintBackgroundTimeLength() {
        let message = "本次后台持续时间:\(backgroundTimeLength)s"
        print("🍎🍎🍎 \(Date()) \(NSStringFromClass(classForCoder))::\(message)")
    }
}

// MARK: - 扩展 播放代理
extension DHBackgroundRunnerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        debugPrint("\(type(of: self))" + error.debugDescription)
    }
}
