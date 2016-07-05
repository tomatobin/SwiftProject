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
    var captureStillImageOutput: AVCaptureStillImageOutput! //照片输出流
    var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer! //相机拍摄预览图层
    
    @IBOutlet weak var focusCursor: UIImageView! //聚集光标
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCapture()
    }
    
    func setupCapture(){
        if captureSession == nil {
            captureSession = AVCaptureSession()
            if captureSession.canSetSessionPreset(AVCaptureSessionPreset1280x720) {
                captureSession.sessionPreset = AVCaptureSessionPreset1280x720
            }
        }
        
        //获得输入设备
        let captureDevice = self.getCameraDevice(.Back)
        if captureDevice == nil {
            ColorLog.red("获取后置摄像头错误")
            return;
        }

        //初始化输入设备
        do{
            captureDeviceInput = try AVCaptureDeviceInput.init(device: captureDevice)
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
        captureVideoPreviewLayer.frame = self.containerView.bounds
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //将视频预览层添加到界面中
        layer.insertSublayer(captureVideoPreviewLayer, below: focusCursor.layer)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.captureSession.startRunning()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func getCameraDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let cameras = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for camera in cameras {
            if camera.position == position {
                return camera as? AVCaptureDevice
            }
        }
        
        return nil
    }
    
    //MARK: - Foucus
    func addGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(CameraCaptureController.tapScreen))
        self.containerView.addGestureRecognizer(tapGesture)
    }
    
    func tapScreen(gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.locationInView(self.containerView)
        let cameraPoint = self.captureVideoPreviewLayer.captureDevicePointOfInterestForPoint(point)
        self.adjustFoucusCursorPosition(point)
        self.focusCursor(.AutoFocus, exposureMode: .AutoExpose, point: cameraPoint)
    }
    
    func adjustFoucusCursorPosition(point: CGPoint){
        self.focusCursor.center = point
        self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5)
        self.focusCursor.alpha = 1
        
        UIView.animateWithDuration(0.3, animations: {
            self.focusCursor.transform = CGAffineTransformIdentity
        }, completion: {_ in
            self.focusCursor.alpha = 0
        })
    }
    
    func focusCursor(focusMode: AVCaptureFocusMode, exposureMode: AVCaptureExposureMode, point: CGPoint){
        self.changeDeviceProperty{ captureDevice in
            if captureDevice.isFocusModeSupported(focusMode){
                captureDevice.focusMode = .AutoFocus
            }
            if captureDevice.isExposureModeSupported(exposureMode){
                captureDevice.exposureMode = .AutoExpose
            }
        }
    }
    
    func changeDeviceProperty(propertyChange: PropertyChangeBlock){
        let captureDevice = self.captureDeviceInput.device
        do{
            try captureDevice.lockForConfiguration()
            propertyChange(captureDevice)
            captureDevice.unlockForConfiguration()
       
        }catch{
            ColorLog.red("设置设备属性过程发生错误")
        }
    }
}
