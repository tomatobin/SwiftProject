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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initAudioSession(){
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback) //AVAudioSessionCategorySoloAmbient AVAudioSessionCategoryPlayback
        try! audioSession.setActive(true)
    }
    
    func initAudioPlayer(){
        let filePath = NSBundle.mainBundle().pathForResource("Liekkas", ofType: "mp3")
        let fileURL = NSURL(fileURLWithPath: filePath!)
        audioPlayer = try! AVAudioPlayer.init(contentsOfURL: fileURL)
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay() //预播放
    }
    
    @IBAction func onPlayAction(sender: AnyObject) {
        if audioPlayer.playing {
            btnPlay.setButtonState(.Paused, animated: true)
            audioPlayer.pause()
        }
        else{
            btnPlay.setButtonState(.Playing, animated: true)
            audioPlayer.play()
            self.showPlayInfo()
        }
    }

    func showPlayInfo(){
        
        //如果不接收控制信息，会导致锁屏时显示不了信息
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        // 直接使用defaultCenter来获取MPNowPlayingInfoCenter的默认唯一实例
        let infoCenter = MPNowPlayingInfoCenter.defaultCenter()
        
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
}
