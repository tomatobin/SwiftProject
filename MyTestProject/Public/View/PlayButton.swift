//
//  PlayButton.swift
//  PopPlayButton
//
//  Created by jiangbin on 15/10/29.
//  Copyright © 2015年 iDssTeam. All rights reserved.
//

import Foundation
import pop

//定义button两种状态的枚举

/*
POP allows us to create animatable property — and that is exactly what we are going to do. We will create a CGFloat variable named animationValue and will animate it from 1.0 to 0.0 when the button state changes from Paused to Playing, and animate from 0.0 to 1.0 when the button state changes from Playing to Paused. Every time the value has changed we will call setNeedsDisplay which will force our view to redraw.
*/
enum PlayButtonState {
    case paused
    case playing
    
    var value: CGFloat {
        return (self == .paused) ? 1.0 : 0.0
    }
}

class PlayButton: UIButton {
    fileprivate(set) var buttonState = PlayButtonState.paused
    fileprivate var animationValue: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: -
    // MARK: Methods
    func setButtonState(_ buttonState: PlayButtonState, animated: Bool) {
        // 1
        if self.buttonState == buttonState {
            return
        }
        self.buttonState = buttonState
        
        // 2
        if pop_animation(forKey: "animationValue") != nil {
            pop_removeAnimation(forKey: "animationValue")
        }
        
        // 3
        let toValue: CGFloat = buttonState.value
        
        //kPOPViewAlpha
        
        // 4
        if animated {
            let animation: POPBasicAnimation = POPBasicAnimation()
            if let property = POPAnimatableProperty.property(withName: "animationValue", initializer: { prop in
                prop?.readBlock = { (object: Any?, values: UnsafeMutablePointer<CGFloat>?) -> Void in
                    if let button = object as? PlayButton {
                        values?[0] = button.animationValue
                    }
                }
                
                prop?.writeBlock = { (object: Any?, values: UnsafePointer<CGFloat>?) -> Void in
                    if let button = object as? PlayButton, let animationValues = values {
                        button.animationValue = animationValues[0]
                    }
                }
                
                prop?.threshold = 0.01
                
            }) as? POPAnimatableProperty {
                animation.property = property
            }
            animation.fromValue = NSNumber(value: Float(self.animationValue) as Float)
            animation.toValue = NSNumber(value: Float(toValue) as Float)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.duration = 0.25
            pop_add(animation, forKey: "percentage")
        } else {
            animationValue = toValue
        }
    }
    
    // MARK: -
    // MARK: Draw
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 1
        let height = rect.height
        let minWidth = rect.width * 0.32
        let aWidth = (rect.width / 2.0 - minWidth) * animationValue
        let width = minWidth + aWidth
        let h1 = height / 4.0 * animationValue
        let h2 = height / 2.0 * animationValue
        
        // 2
        let context = UIGraphicsGetCurrentContext()
        
        // 3
        context!.move(to: CGPoint(x: 0.0, y: 0.0))
        context!.addLine(to: CGPoint(x: width, y: h1))
        context!.addLine(to: CGPoint(x: width, y: height - h1))
        context!.addLine(to: CGPoint(x: 0.0, y: height))
        context!.move(to: CGPoint(x: rect.width - width, y: h1))
        context!.addLine(to: CGPoint(x: rect.width, y: h2))
        context!.addLine(to: CGPoint(x: rect.width, y: height - h2))
        context!.addLine(to: CGPoint(x: rect.width - width, y: height - h1))
        
        // 4
        context!.setFillColor(tintColor.cgColor)
        context!.fillPath()
    }
}
