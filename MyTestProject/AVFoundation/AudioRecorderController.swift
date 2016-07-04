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
    var audioPlayer: AVAudioPlayer?
    var timer: NSTimer!
    
    @IBOutlet weak var audioPowerProgress: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initAudioRecorder()
        self.initTimer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func initTimer(){
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector:  #selector(AudioRecorderController.audioPowerChange), userInfo: nil, repeats: true)
        }
    }
    
    func audioPowerChange(){
        var power = Float(-160)
        if  audioRecorder.recording {
            audioRecorder.updateMeters() //更新测量值
            power = audioRecorder.averagePowerForChannel(0) //第一个通道音频，强度-160~0
            ColorLog.green("Power:\(power)")
        }
        
        let progress = (1.0 / 160.0)*(power + 160.0)
        self.audioPowerProgress.setProgress(progress, animated: true)
    }
    
    func setAudionSession(category: String){
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(category)
        try! audioSession.setActive(true)
    }
    
    func initAudioRecorder(){
        self.setAudionSession(AVAudioSessionCategoryPlayAndRecord)
        let pathURL = self.filePath() //创建录音文件保存路径
        let dicSettings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM), //格式
                           AVSampleRateKey: NSNumber(unsignedInt: 16000),  //设置录音采样率
                           AVNumberOfChannelsKey: NSNumber(unsignedInt: 2), //设置通道,这里采用单声道
                           AVLinearPCMBitDepthKey: NSNumber(unsignedInt: 16), //每个采样点位数,分为8、16、24、32
                           AVLinearPCMIsFloatKey: NSNumber(bool: true), //是否使用浮点数采样
                           ] as Dictionary<String,AnyObject>
        self.audioRecorder = try! AVAudioRecorder.init(URL: pathURL, settings: dicSettings)
        self.audioRecorder.delegate = self
        self.audioRecorder.peakPowerForChannel(0)
        self.audioRecorder.meteringEnabled = true // 如果要监控声波则必须设置为YES
    }
    
    func initAudioPlayer(){
        let fileURL = self.filePath()
        do{
            self.setAudionSession(AVAudioSessionCategoryPlayback) //播放时需要重新设置Category为Playback，否则会导致非常小
            audioPlayer = try AVAudioPlayer.init(contentsOfURL: fileURL)
            audioPlayer!.delegate = self
            audioPlayer!.volume = 1.0
            audioPlayer!.prepareToPlay() //预播放
        }
        catch{
            audioPlayer = nil
        }
    }
    
    //MARK: - Actions
    @IBAction func onRecordAction(sender: AnyObject) {
        if self.audioPlayer != nil {
            self.audioPlayer!.stop()
        }
        
        if !self.audioRecorder.recording {
            self.audioRecorder.record()
        }
    }
    
    @IBAction func onStopAction(sender: AnyObject) {
        self.audioRecorder.stop()
        if self.audioPlayer != nil {
            self.audioPlayer!.stop()
        }
    }
    
    @IBAction func onPlayAction(sender: AnyObject) {
        self.audioRecorder.stop()
        self.initAudioPlayer()
        self.audioPlayer?.play()
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

