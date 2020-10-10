//
//  CameraCaptureController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/5.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit
import AVFoundation

typealias PropertyChangeBlock = (AVCaptureDevice) -> Void

class CameraCaptureController: FPBaseController {
    var captureSession: AVCaptureSession! //负责输入和输出设置之间的数据传递
    var captureDeviceInput: AVCaptureDeviceInput! //负责从AVCaptureDevice获得输入数据
    var captureStillImageOutput: AVCaptureStillImageOutput! //照片输出流 [AVCaptureMovieFileOutput]视频输出流
    var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer! //相机拍摄预览图层
    
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var btnFlipCamera: UIButton!
    @IBOutlet weak var focusCursor: UIImageView! //聚集光标
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.focusCursor.alpha = 0
        self.captureImageView.alpha = 0
        self.captureImageView.frame = CGRect(x: 0, y: 55, width: self.view.bounds.width, height: self.containerView.bounds.height + 64)
        self.captureImageView.backgroundColor = UIColor.red
        
        self.setupCapture()
        self.addGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func setupCapture(){
        if captureSession == nil {
            captureSession = AVCaptureSession()
            if captureSession.canSetSessionPreset(AVCaptureSession.Preset.hd1280x720) {
                captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
            }
        }
        
        //获得输入设备
        let captureDevice = self.getCameraDevice(.back)
        if captureDevice == nil {
            ColorLog.red("获取后置摄像头错误")
            return;
        }

        //初始化输入设备
        do{
			captureDeviceInput = try AVCaptureDeviceInput.init(device: captureDevice!)
        }catch{
            ColorLog.red("获取输对象错误")
            return;
        }
        
        //初始化设备输出对象
        captureStillImageOutput = AVCaptureStillImageOutput()
        let dicSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureStillImageOutput.outputSettings = dicSettings
        
        //将设备输入、输出添加到会话中
        if captureSession.canAddInput(captureDeviceInput) {
            captureSession.addInput(captureDeviceInput)
        }
        if captureSession.canAddOutput(captureStillImageOutput) {
            captureSession.addOutput(captureStillImageOutput)
        }
        
        //创建视频预览层，用于实时展示摄像头状态
        captureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        let layer = self.containerView.layer
        layer.masksToBounds = true
        captureVideoPreviewLayer.frame = layer.bounds
		captureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        //将视频预览层添加到界面中
        layer.insertSublayer(captureVideoPreviewLayer, below: focusCursor.layer)
    }
    
	func getCameraDevice(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
		let cameras = AVCaptureDevice.devices(for: AVMediaType.video)
		for camera in cameras {
            if (camera as AnyObject).position == position {
                return camera
            }
        }
        
        return nil
    }
    
    //MARK: - Foucus
    func addGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(CameraCaptureController.tapScreen))
        self.containerView.addGestureRecognizer(tapGesture)
    }
    
	@objc func tapScreen(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: self.containerView)
		let cameraPoint = self.captureVideoPreviewLayer.captureDevicePointConverted(fromLayerPoint: point)
        self.adjustFoucusCursorPosition(point)
        self.focusCursor(.autoFocus, exposureMode: .autoExpose, point: cameraPoint)
    }
    
    func adjustFoucusCursorPosition(_ point: CGPoint){
        self.focusCursor.center = point
        self.focusCursor.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.focusCursor.alpha = 1
        
        UIView.animate(withDuration: 0.3, animations: {
            self.focusCursor.transform = CGAffineTransform.identity
        }, completion: {_ in
            self.focusCursor.alpha = 0
        })
    }
    
	func focusCursor(_ focusMode: AVCaptureDevice.FocusMode, exposureMode: AVCaptureDevice.ExposureMode, point: CGPoint){
        self.changeDeviceProperty{ captureDevice in
            if captureDevice.isFocusModeSupported(focusMode){
                captureDevice.focusMode = .autoFocus
            }
            if captureDevice.isExposureModeSupported(exposureMode){
                captureDevice.exposureMode = .autoExpose
            }
        }
    }
    
    func changeDeviceProperty(_ propertyChange: PropertyChangeBlock){
        let captureDevice = self.captureDeviceInput.device
        do{
			try captureDevice.lockForConfiguration()
			propertyChange(captureDevice)
			captureDevice.unlockForConfiguration()
       
        }catch{
            ColorLog.red("设置设备属性过程发生错误")
        }
    }
    
    //MARK: - Animations
    func showCaptureImageViewAnimated(){
        self.captureImageView.alpha = 1
        UIView.transition(with: self.captureImageView, duration: 1.0, options: UIView.AnimationOptions(), animations: {
            self.captureImageView.alpha = 0
            self.captureImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }, completion: {_ in
            self.captureImageView.alpha = 0
            self.captureImageView.transform = CGAffineTransform.identity
        })
    }
    
    //MARK: - Actions
    @IBAction func onFlipCameraAction(_ sender: AnyObject) {
        let currentDevice = self.captureDeviceInput.device
		let currenPositon = currentDevice.position
        
        var toChangeDevice = AVCaptureDevice(uniqueID: "back")
		var toChangePosition = AVCaptureDevice.Position.front
        if currenPositon == .unspecified || currenPositon == .front {
            toChangePosition = .back
        }
        
        toChangeDevice = self.getCameraDevice(toChangePosition)
        
        //获得要调整的设备输入对象
        do{
			let toChangeDeviceInput = try AVCaptureDeviceInput.init(device: toChangeDevice!)
            self.captureSession.beginConfiguration()
            self.captureSession.removeInput(self.captureDeviceInput)
            if self.captureSession.canAddInput(toChangeDeviceInput) {
                self.captureSession.addInput(toChangeDeviceInput)
                self.captureDeviceInput = toChangeDeviceInput
                ColorLog.green("切换前后摄像头成功")
            }
            self.captureSession.commitConfiguration()
        }catch{
            ColorLog.red("切换前后摄像头失败")
        }
    }
    
    @IBAction func onCaptureAction(_ sender: AnyObject) {
        //根据设备输出获得连接
		let captureConnection = self.captureStillImageOutput.connection(with: AVMediaType.video)
		self.captureStillImageOutput.captureStillImageAsynchronously(from: captureConnection!, completionHandler: {(imageDataSampleBuffer, error) in
            if imageDataSampleBuffer != nil{
				let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                let image = UIImage(data: imageData!)
                self.captureImageView.image = image
                self.showCaptureImageViewAnimated()
                //UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil) //保存到相册中
            }
        })
    }
}
