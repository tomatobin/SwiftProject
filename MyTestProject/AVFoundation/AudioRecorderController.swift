//
//  AudioRecorderController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/4.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorderController: FPBaseController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initAudioSession()
        self.initAudioRecorder()
    }
    
    func initAudioSession(){
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioSession.setActive(true)
    }
    
    func initAudioRecorder(){
        let pathURL = self.filePath() //创建录音文件保存路径
        let dicSettings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM), //格式
                           AVSampleRateKey: NSNumber(unsignedInt: 16000),  //设置录音采样率
                           AVNumberOfChannelsKey: NSNumber(unsignedInt: 1), //设置通道,这里采用单声道
                           AVLinearPCMBitDepthKey: NSNumber(unsignedInt: 16), //每个采样点位数,分为8、16、24、32
                           AVLinearPCMIsFloatKey: NSNumber(bool: true), //是否使用浮点数采样
                           ] as Dictionary<String,AnyObject>
        self.audioRecorder = try! AVAudioRecorder.init(URL: pathURL, settings: dicSettings)
        self.audioRecorder.delegate = self
        self.audioRecorder.meteringEnabled = true // 如果要监控声波则必须设置为YES
    }
    
    func initAudioPlayer(){
        let fileURL = self.filePath()
        do{
            audioPlayer = try AVAudioPlayer.init(contentsOfURL: fileURL)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay() //预播放
        }
        catch{
            audioPlayer = nil
        }
    }
    
    //MARK: - Actions
    @IBAction func onRecordAction(sender: AnyObject) {
        if !self.audioRecorder.recording {
            self.audioRecorder.record()
        }
    }
    
    @IBAction func onStopAction(sender: AnyObject) {
        self.audioRecorder.stop()
        if self.audioPlayer != nil {
            self.audioPlayer.stop()
        }
    }
    
    @IBAction func onPlayAction(sender: AnyObject) {
        self.audioRecorder.stop()
        self.initAudioPlayer()
        self.audioPlayer.play()
    }
    
    
    //MARK: - Private
    func filePath() -> NSURL {
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
        path = path?.stringByAppendingString("/myRecord.caf")
        ColorLog.green("Save path: \(path)")
        let url  = NSURL(fileURLWithPath: path!)
        return url
    }
    
    
    //MARK: - Delegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        ColorLog.green("Record finished!")
    }
}

