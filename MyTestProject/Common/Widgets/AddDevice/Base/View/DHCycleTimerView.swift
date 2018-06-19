//
//  DHCycleTimerView.swift
//  LeChangeOverseas
//
//  Created by iblue on 2018/6/6.
//  Copyright © 2018年 dh. All rights reserved.
//	动画如果采用CABaseAnimation的方法，无法处理进入后台的问题，统一使用定时器进行绘制
//	由于使用了定时器，在不使用的时候，需要调用stopTimer()方法进行销毁
//	UILabel富文本在文字较少的时候，行间距设置无效，使用两个Label进行显示

import UIKit

@objc public protocol DHCycleTimerViewDelegate: NSObjectProtocol {
	
	func cycleTimerViewTimeout(cycleView: DHCycleTimerView)
	
	func cycleTimerView(cycleView: DHCycleTimerView, tick: Int)
}

@objc public class DHCycleTimerView: UIView {
	
	@objc public weak var delegate: DHCycleTimerViewDelegate?
	
	/// 超时的闭包，外层需要注意循环引用的问题
	@objc public var timeout: (()->())?
	
	/// 线条宽度
	@objc public var progressWidth : CGFloat = 3 {
		didSet{
			bottomLayer.lineWidth = progressWidth
			progressLayer.lineWidth = progressWidth
		}
	}
	
	/// 进度条底色
	@objc public var progressBackgroundColor: UIColor = UIColor.lightGray {
		didSet {
			bottomLayer.strokeColor = progressBackgroundColor.cgColor
		}
	}
	
	/// 进度条前景颜色
	@objc public var progressForegroundColor: UIColor = UIColor.orange {
		didSet{
			progressLayer.strokeColor = progressForegroundColor.cgColor
		}
	}
	
	/// 倒计时总时间
	@objc public var maxTime: Int = 30
	
	/// 当前计时时间
	private var currentTime: Int = 0
	
	/// 计时器计数（毫秒）
	private var millisecondsCount: TimeInterval = 0
	
	private var origin : CGPoint = CGPoint(x: 0, y: 0)
	private var radius : CGFloat = 0
	
	/// 起始点
	private var startAngle : CGFloat = -CGFloat(Double.pi / 2)
	
	/// 定时器
	private var timer: DispatchSourceTimer?
	
	/// 标记是否开始
	private var isStarted: Bool = false
	
	/// 内容label
	private lazy var contentLabel : UILabel = {
		let label = UILabel()
		label.textColor = UIColor.orange
		label.textAlignment = .center
		label.font = UIFont.boldSystemFont(ofSize: 25)
		return label
	}()
	
	///秒数label
	private lazy var secondLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.orange
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 20)
		label.text = "s"
		return label
	}()
	
	private lazy var bottomLayer : CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.fillColor = UIColor.clear.cgColor
		layer.lineWidth = progressWidth
		layer.strokeColor = progressBackgroundColor.cgColor
		return layer
	}()
	
	private lazy var progressLayer : CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.lineCap = kCALineCapRound
		layer.fillColor = UIColor.clear.cgColor
		layer.lineWidth = progressWidth
		layer.strokeColor = progressForegroundColor.cgColor
		return layer
	}()
	
	//MARK: Init Methods
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.white
		setupLayers()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		backgroundColor = UIColor.clear
		setupLayers()
	}
	
	func setupLayers() {
		layer.addSublayer(bottomLayer)
		layer.addSublayer(progressLayer)
		addSubview(secondLabel)
		addSubview(contentLabel)
		
		secondLabel.snp.makeConstraints { make in
			make.left.width.equalTo(self)
			make.height.equalTo(20)
			make.top.equalTo(self.snp.centerY).offset(5)
		}
		
		contentLabel.snp.makeConstraints { make in
			make.left.width.equalTo(self)
			make.height.equalTo(20)
			make.bottom.equalTo(secondLabel.snp.top)
		}
		
		origin = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
		radius = self.bounds.size.width / 2
		let bottomPath  = UIBezierPath.init(arcCenter: origin, radius: radius, startAngle: startAngle, endAngle: CGFloat(Double.pi * 2), clockwise: true)
		bottomLayer.path = bottomPath.cgPath
	}
	
	//MARK: Timer Process
	@objc public func startTimer() {
		startTimer(reset: true)
	}
	
	@objc public func stopTimer() {
		timer?.cancel()
		isStarted = false
	}
	
	@objc public func pauseTimer() {
		timer?.cancel()
		isStarted = false
	}
	
	@objc public func resumeTimer() {
		startTimer(reset: false)
	}
	
	private func startTimer(reset: Bool) {
		if isStarted == true {
			return
		}
		
		isStarted = true
		
		//重置或者超时后，重新开启
		if reset || currentTime >= maxTime {
			currentTime = 0
			millisecondsCount = 0
			progressLayer.removeAllAnimations()
			drawProgressPath()
		}
		
		//设置开始的时间
		updateProgressText()
		
		//屏幕刷新50HZ为参考
		let interval = TimeInterval(1/50.0) * 1000
		
		timer = DispatchSource.makeTimerSource(flags: [], queue:  DispatchQueue.main)
		timer!.schedule(deadline: DispatchTime.now(), repeating: .milliseconds(Int(interval)), leeway: .microseconds(10))
		timer!.setEventHandler {
			//print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::\(self.currentTime)-\(self.millisecondsCount)-\(self)")
			
			if self.isStarted, self.currentTime >= self.maxTime {
				self.timeoutProcess()
				self.delegate?.cycleTimerViewTimeout(cycleView: self)
				return
			}
			
			self.millisecondsCount += interval
			self.currentTime = Int(self.millisecondsCount / 1000)
			self.updateProgressText()
			self.drawProgressPath()
			
			//传出时间
			if Int(self.millisecondsCount) % 1000 == 0 {
				self.delegate?.cycleTimerView(cycleView: self, tick: self.currentTime)
			}
		}
		
		timer?.resume()
	}
	
	private func timeoutProcess() {
		timeout?()
		stopTimer()
	}
	
	//MARK: Draw Path
	private func drawProgressPath() {
		if isStarted == false {
			return
		}
		
		let endAngle = startAngle + CGFloat(millisecondsCount / 1000) * CGFloat(Double.pi * 2) / CGFloat(maxTime)
		let topPath = UIBezierPath(arcCenter: origin, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		progressLayer.path = topPath.cgPath
	}
	
	private func updateProgressText() {
		contentLabel.text = "\(self.maxTime - self.currentTime)"
	}
	
	private func multilineTextHeight(font: UIFont) -> CGFloat {
		
		let size = CGSize(width: self.bounds.width, height: self.bounds.height)
		let style = NSMutableParagraphStyle()
		style.lineBreakMode = NSLineBreakMode.byCharWrapping
		style.lineSpacing = 10
		
		let attributes = [NSAttributedStringKey.font: font,
						  NSAttributedStringKey.paragraphStyle: style]
		
		let text = "Test\nTest" as NSString
		let rect = text.boundingRect(with: size,
									 options: NSStringDrawingOptions.usesLineFragmentOrigin,
									 attributes: attributes,
									 context: nil)
		
		return rect.size.height
	}
	
	//MARK: Deinit
	deinit {
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: dealloced...")
	}
}
