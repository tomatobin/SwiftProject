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

    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var timer: Timer!
    
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var audioPowerProgress: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initTimer()
        self.audioPowerProgress.setProgress(0, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func initTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:  #selector(AudioRecorderController.audioPowerChange), userInfo: nil, repeats: true)
            timer.fireDate = Date.distantFuture
        }
    }
    
    //MARK: - Recorder & Player
	@objc func audioPowerChange(){
        var power = Float(-160)
        if audioRecorder?.isRecording != nil {
            audioRecorder!.updateMeters() //更新测量值
            power = audioRecorder!.averagePower(forChannel: 0) //第一个通道音频，强度-160~0
        }
        else if audioPlayer?.isPlaying != nil{
            audioPlayer!.updateMeters() //更新测量值
            power = audioPlayer!.averagePower(forChannel: 0) //第一个通道音频，强度-160~0
        }
        
        ColorLog.green("Power:\(power)")
        let progress = (1.0 / 160.0)*(power + 160.0)
        self.audioPowerProgress.setProgress(progress, animated: true)
    }
    
    func setAudionSession(_ category: String){
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSession.Category(rawValue: category))
        try! audioSession.setActive(true)
    }
    
    func initAudioRecorder(){
        self.setAudionSession(AVAudioSession.Category.playAndRecord.rawValue)
        let pathURL = self.filePath() //创建录音文件保存路径
        let dicSettings = [AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM as UInt32), //格式
                           AVSampleRateKey: NSNumber(value: 16000 as UInt32),  //设置录音采样率
                           AVNumberOfChannelsKey: NSNumber(value: 2 as UInt32), //设置通道,这里采用单声道
                           AVLinearPCMBitDepthKey: NSNumber(value: 16 as UInt32), //每个采样点位数,分为8、16、24、32
                           AVLinearPCMIsFloatKey: NSNumber(value: true as Bool), //是否使用浮点数采样
                           ] as Dictionary<String,AnyObject>
        do{
            self.audioRecorder = try AVAudioRecorder.init(url: pathURL, settings: dicSettings)
            self.audioRecorder!.delegate = self
            self.audioRecorder!.peakPower(forChannel: 0)
            self.audioRecorder!.isMeteringEnabled = true // 如果要监控声波则必须设置为YES
        }catch{
            self.audioRecorder = nil
        }
    }
    
    func initAudioPlayer() -> Bool {
        let fileURL = self.filePath()
        if !FPFileHelper.isFileExsited(fileURL.relativePath) {
            ColorLog.red("Error: File is not existed...")
            return false
        }
        
        do{
            self.setAudionSession(AVAudioSession.Category.playback.rawValue) //播放时需要重新设置Category为Playback，否则会导致非常小
            audioPlayer = try AVAudioPlayer.init(contentsOf: fileURL)
            audioPlayer!.delegate = self
            audioPlayer!.volume = 1.0
            audioPlayer!.isMeteringEnabled = true // 如果要监控声波则必须设置为YES
            audioPlayer!.prepareToPlay() //预播放
            return true
        }
        catch{
            audioPlayer = nil
            return false
        }
    }
    
    //MARK: - Actions
    @IBAction func onRecordAction(_ sender: AnyObject) {
        self.stopPlayer()
        if self.audioRecorder == nil {
            self.initAudioRecorder() //重新初始化录音
        }
        
        if self.audioRecorder == nil {
            ColorLog.red("Init Audio Recorder failed...")
            return;
        }
        
        if !self.audioRecorder!.isRecording  {
            ColorLog.green("Start recording....")
            self.audioRecorder!.record()
            btnRecord.setImage(UIImage(named: "record_on"), for: UIControl.State())
            self.timer.fireDate = Date.distantPast
        }
        else{
            ColorLog.green("Pause recording....")
            self.audioRecorder!.pause()
            btnRecord.setImage(UIImage(named: "record_off"), for: UIControl.State())
            self.timer.fireDate = Date.distantFuture
        }
    }
    
    @IBAction func onStopAction(_ sender: AnyObject) {
        self.timer.fireDate = Date.distantFuture
        self.stopRecorder()
        self.stopPlayer()
        self.audioPowerProgress.setProgress(0, animated: true)
    }
    
    @IBAction func onPlayAction(_ sender: AnyObject) {
        self.stopRecorder()
        if self.audioPlayer == nil {
            if !self.initAudioPlayer() {
                ColorLog.red("Init Audio Player failed...")
                return
            }
        }
        
        if self.audioPlayer!.isPlaying == false
        {
            //继续播放
            if self.audioPlayer!.play() {
                btnPlay.setImage(UIImage(named: "pause"), for: UIControl.State())
                self.timer.fireDate = Date.distantPast
                ColorLog.green("Play succeed....")
            }
            else{
                ColorLog.red("Play failed...")
            }
        }
        else
        {
            //暂停播放
            btnPlay.setImage(UIImage(named: "play"), for: UIControl.State())
            self.audioPlayer?.pause()
            self.timer.fireDate = Date.distantFuture
        }
    }
    
    //MARK: - Private
    func filePath() -> URL {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        path = (path)! + "/myRecord.caf"
        ColorLog.green("File path: \(String(describing: path))")
        let url  = URL(fileURLWithPath: path!)
        return url
    }
    
    func stopRecorder(){
        if self.audioRecorder != nil {
            self.audioRecorder!.stop()
            self.audioRecorder = nil
        }
        
        //Reset the button image
        btnRecord.setImage(UIImage(named: "record_off"), for: UIControl.State())
    }
    
    func stopPlayer(){
        if self.audioPlayer != nil {
            self.audioPlayer!.stop()
            self.audioPlayer = nil
        }
        
        //Reset the button image
        btnPlay.setImage(UIImage(named: "play"), for: UIControl.State())
    }
    
    //MARK: - Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        ColorLog.green("Record finished!")
        self.stopRecorder()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        ColorLog.green("Play finished")
        self.stopPlayer()
    }
}

