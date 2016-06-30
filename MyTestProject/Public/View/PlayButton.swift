//
//  PlayButton.swift
//  PopPlayButton
//
//  Created by jiangbin on 15/10/29.
//  Copyright © 2015年 iDssTeam. All rights reserved.
//

import Foundation

//定义button两种状态的枚举

/*
POP allows us to create animatable property — and that is exactly what we are going to do. We will create a CGFloat variable named animationValue and will animate it from 1.0 to 0.0 when the button state changes from Paused to Playing, and animate from 0.0 to 1.0 when the button state changes from Playing to Paused. Every time the value has changed we will call setNeedsDisplay which will force our view to redraw.
*/
enum PlayButtonState {
    case Paused
    case Playing
    
    var value: CGFloat {
        return (self == .Paused) ? 1.0 : 0.0
    }
}

class PlayButton: UIButton {
    private(set) var buttonState = PlayButtonState.Paused
    private var animationValue: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: -
    // MARK: Methods
    func setButtonState(buttonState: PlayButtonState, animated: Bool) {
        // 1
        if self.buttonState == buttonState {
            return
        }
        self.buttonState = buttonState
        
        // 2
        if pop_animationForKey("animationValue") != nil {
            pop_removeAnimationForKey("animationValue")
        }
        
        // 3
        let toValue: CGFloat = buttonState.value
        
        //kPOPViewAlpha
        
        // 4
        if animated {
            let animation: POPBasicAnimation = POPBasicAnimation()
            if let property = POPAnimatableProperty.propertyWithName("animationValue", initializer: { (prop: POPMutableAnimatableProperty!) -> Void in
                prop.readBlock = { (object: AnyObject!, values: UnsafeMutablePointer<CGFloat>) -> Void in
                    if let button = object as? PlayButton {
                        values[0] = button.animationValue
                    }
                }
                prop.writeBlock = { (object: AnyObject!, values: UnsafePointer<CGFloat>) -> Void in
                    if let button = object as? PlayButton {
                        button.animationValue = values[0]
                    }
                }
                prop.threshold = 0.01
            }) as? POPAnimatableProperty {
                animation.property = property
            }
            animation.fromValue = NSNumber(float: Float(self.animationValue))
            animation.toValue = NSNumber(float: Float(toValue))
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.duration = 0.25
            pop_addAnimation(animation, forKey: "percentage")
        } else {
            animationValue = toValue
        }
    }
    
    // MARK: -
    // MARK: Draw
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
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
        CGContextMoveToPoint(context, 0.0, 0.0)
        CGContextAddLineToPoint(context, width, h1)
        CGContextAddLineToPoint(context, width, height - h1)
        CGContextAddLineToPoint(context, 0.0, height)
        CGContextMoveToPoint(context, rect.width - width, h1)
        CGContextAddLineToPoint(context, rect.width, h2)
        CGContextAddLineToPoint(context, rect.width, height - h2)
        CGContextAddLineToPoint(context, rect.width - width, height - h1)
        
        // 4
        CGContextSetFillColorWithColor(context, tintColor.CGColor)
        CGContextFillPath(context)
    }
}
