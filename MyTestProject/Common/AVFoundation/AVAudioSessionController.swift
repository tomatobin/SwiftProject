//
//  AVAudioSessionController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/6/30.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit
import AVFoundation
import AudioUnit

//导入MediaPlayer，为了显示锁屏信息
import MediaPlayer

class AVAudioSessionController: FPBaseController,AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    
    //MPMoviePlayerController

    @IBOutlet weak var btnPlay: PlayButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initAudioSession()
        self.initAudioPlayer()
        self.addNotifications() //添加耳机监听事件
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.stopAudioPlayer()
        self.removeNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(routeChanged), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    func removeNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func initAudioSession(){
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback) //AVAudioSessionCategorySoloAmbient AVAudioSessionCategoryPlayback
        try! audioSession.setActive(true)
    }
    
    func initAudioPlayer(){
        let filePath = Bundle.main.path(forResource: "Liekkas", ofType: "mp3")
        let fileURL = URL(fileURLWithPath: filePath!)
        audioPlayer = try! AVAudioPlayer.init(contentsOf: fileURL)
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay() //预播放
    }
    
    func stopAudioPlayer(){
        if audioPlayer != nil {
            audioPlayer.stop()
            audioPlayer = nil
        }
    }
    
	@objc func routeChanged(_ notification: Notification){
        let dictionary = notification.userInfo
        let changeReason = (dictionary![AVAudioSessionRouteChangeReasonKey] as AnyObject).uint32Value
        ColorLog.green("Change Reason:\(changeReason ?? 0)") // AVAudioSessionRouteChangeReason
    }
    
    @IBAction func onPlayAction(_ sender: AnyObject) {
        if audioPlayer.isPlaying {
            btnPlay.setButtonState(.paused, animated: true)
            audioPlayer.pause()
        }
        else{
            btnPlay.setButtonState(.playing, animated: true)
            audioPlayer.play()
            self.showPlayInfo()
        }
    }

    func showPlayInfo(){
        
        //如果不接收控制信息，会导致锁屏时显示不了信息
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        // 直接使用defaultCenter来获取MPNowPlayingInfoCenter的默认唯一实例
        let infoCenter = MPNowPlayingInfoCenter.default()
        
        let albumArt = MPMediaItemArtwork(image: UIImage(named: "Liekkas")!)

        // 通过配置nowPlayingInfo的值来更新锁屏界面的信息
        infoCenter.nowPlayingInfo = [
            // 歌曲名
            MPMediaItemPropertyTitle : "Liekkas",
            // 艺术家名
            MPMediaItemPropertyArtist : "Sofia Jannok",
            
            MPMediaItemPropertyArtwork: albumArt
        ]
    }
    
    //MARK: - AVAudioPlayerDelegate
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        ColorLog.green("Receive interrupt...")
    }
    
//    func audioPlayerEndInterruption(_ player: AVAudioPlayer) {
//        ColorLog.green("End interrupt...")
//    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        ColorLog.green("Music play over...")
    }
}
