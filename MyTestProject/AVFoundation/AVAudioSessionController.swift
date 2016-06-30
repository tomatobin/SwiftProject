//
//  AVAudioSessionController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/6/30.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit
import AVFoundation

class AVAudioSessionController: FPBaseController,AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!

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
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
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
        }
    }

}
