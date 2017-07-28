//
//  SoccerFieldView.swift
//  MyTestProject
//
//  Created by iblue on 2017/7/28.
//  Copyright © 2017年 iblue. All rights reserved.
//

import UIKit

import UIKit

let FIELD_DEFAULT_WIDTH: CGFloat = 68                //场地宽度
let FIELD_DEFAULT_LENGTH: CGFloat = 105              //场地长度
let GOAL_DEFAULT_WIDTH: CGFloat = 7.32               //球门宽度
let PENALTY_AREA_DEFAULT_WIDTH: CGFloat = 16.5       //大禁区宽度
let PENALTY_AREA_DEFAULT_LENGTH: CGFloat = 40.32     //大禁区长度
let GOAL_AREA_DEFAULT_WIDTH: CGFloat = 5.5           //小禁区宽度
let GOAL_AREA_DEFAULT_LENGTH: CGFloat = 18.32        //小禁区长度
let CENTER_CIRCLE_DEFAULT_RADIUS: CGFloat = 9.15     //中圈半径
let PENALTY_MARK_DEFAULT_DISTANCE: CGFloat = 11      //点球点距离球门线距离
let PENALTY_ARC_DEFAULT_RADIUS: CGFloat = 9.15       //罚球弧半径
let CORNER_AREA_DEFAULT_RADIUS: CGFloat = 1          //角球区半径
let FIELD_GREEN_COLOR = UIColor(red: 6/255.0, green: 148/255.0, blue: 66/255.0, alpha: 1)
let FIELD_LEFT_SPACE: CGFloat = 30

class SoccerFieldView: UIView {
    
    private var homeFormation: String!
    private var guestFormation: String!
    
    convenience init(homeFormation: String, guestFormation: String) {
        self.init()
        print(homeFormation, guestFormation)
        self.homeFormation = homeFormation
        self.guestFormation = guestFormation
        
        self.frame = CGRect(x: 0, y: 0, width: FP_SCREEN_WIDTH, height: FP_SCREEN_WIDTH * FIELD_DEFAULT_LENGTH / FIELD_DEFAULT_WIDTH)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        //背景色设为绿色
        context?.setFillColor(FIELD_GREEN_COLOR.cgColor)
        context?.fill(rect)
        //设置画笔参数
        context?.setStrokeColor(red: 1, green: 1, blue: 1, alpha: 1)
        context?.setLineWidth(3)
        context?.setFillColor(UIColor.white.cgColor)
        //准备坐标参数
        let fieldWidth = FP_SCREEN_WIDTH - FIELD_LEFT_SPACE * 2                   //实际场地宽度
        let fieldLength = fieldWidth * FIELD_DEFAULT_LENGTH / FIELD_DEFAULT_WIDTH   //实际场地长度
        let fieldTopSpace = (self.frame.size.height - fieldLength) / 2              //不同的设备顶部空间不同
        let scale = fieldWidth / FIELD_DEFAULT_WIDTH                                //比例尺
        //画场地边框
        let cornerPoint1 = CGPoint(x: FIELD_LEFT_SPACE, y: fieldTopSpace)
        let cornerPoint2 = CGPoint(x: FIELD_LEFT_SPACE + fieldWidth, y: fieldTopSpace)
        let cornerPoint3 = CGPoint(x: FIELD_LEFT_SPACE + fieldWidth, y: fieldTopSpace + fieldLength)
        let cornerPoint4 = CGPoint(x: FIELD_LEFT_SPACE, y: fieldTopSpace + fieldLength)
        let cornerPoints = [cornerPoint1, cornerPoint2, cornerPoint3, cornerPoint4]
        context?.addLines(between: cornerPoints)
        context?.closePath()
        context?.drawPath(using: .stroke)
        //画四个角球区
        //startAngle:开始角度，endAngle:结束角度，clockwise:顺时针/逆时针
        context?.addArc(center: cornerPoint1, radius: 15, startAngle: 0, endAngle: 0.5 * CGFloat(Double.pi), clockwise: false)
        context?.drawPath(using: .stroke)
        context?.addArc(center: cornerPoint2, radius: 15, startAngle: 0.5 * CGFloat(Double.pi), endAngle: CGFloat(Double.pi), clockwise: false)
        context?.drawPath(using: .stroke)
        context?.addArc(center: cornerPoint3, radius: 15, startAngle: CGFloat(Double.pi), endAngle: 1.5 * CGFloat(Double.pi), clockwise: false)
        context?.drawPath(using: .stroke)
        context?.addArc(center: cornerPoint4, radius: 15, startAngle: 1.5 * CGFloat(Double.pi), endAngle: 0, clockwise: false)
        context?.drawPath(using: .stroke)
        //画中线
        let centerLineLeftPoint = CGPoint(x: FIELD_LEFT_SPACE, y: fieldTopSpace + fieldLength / 2)
        let centerLineRightPoint = CGPoint(x: FIELD_LEFT_SPACE + fieldWidth, y: fieldTopSpace + fieldLength / 2)
        context?.addLines(between: [centerLineLeftPoint, centerLineRightPoint])
        context?.drawPath(using: .stroke)
        //画中圈
        let centerPoint = CGPoint(x: FIELD_LEFT_SPACE + fieldWidth / 2, y: fieldTopSpace + fieldLength / 2)
        context?.addArc(center: centerPoint, radius: scale * CENTER_CIRCLE_DEFAULT_RADIUS, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: false)
        context?.drawPath(using: .stroke)
        //画发球点
        context?.addArc(center: centerPoint, radius: 2, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: false)
        context?.drawPath(using: .stroke)
        //画上方禁区和球门
        let penaltyAreaLength = scale * PENALTY_AREA_DEFAULT_LENGTH         //大禁区长度
        let penaltyAreaWidth = scale * PENALTY_AREA_DEFAULT_WIDTH           //大禁区宽度
        let goalAreaLength = scale * GOAL_AREA_DEFAULT_LENGTH               //小禁区长度
        let goalAreaWidth = scale * GOAL_AREA_DEFAULT_WIDTH                 //小禁区宽度
        let goalWidth = scale * GOAL_DEFAULT_WIDTH                          //球门宽度
        let upPenaltyAreaPoint1 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - penaltyAreaLength) / 2, y: fieldTopSpace)
        let upPenaltyAreaPoint2 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - penaltyAreaLength) / 2, y: fieldTopSpace + penaltyAreaWidth)
        let upPenaltyAreaPoint3 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - penaltyAreaLength) / 2 + penaltyAreaLength, y: fieldTopSpace + penaltyAreaWidth)
        let upPenaltyAreaPoint4 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - penaltyAreaLength) / 2 + penaltyAreaLength, y: fieldTopSpace)
        let upGoalAreaPoint1 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalAreaLength) / 2 + goalAreaLength, y: fieldTopSpace)
        let upGoalAreaPoint2 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalAreaLength) / 2 + goalAreaLength, y: fieldTopSpace + goalAreaWidth)
        let upGoalAreaPoint3 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalAreaLength) / 2, y: fieldTopSpace + goalAreaWidth)
        let upGoalAreaPoint4 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalAreaLength) / 2, y: fieldTopSpace)
        let upGoalPoint1 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalWidth) / 2, y: fieldTopSpace)
        let upGoalPoint2 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalWidth) / 2, y: fieldTopSpace - 15)
        let upGoalPoint3 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalWidth) / 2 + goalWidth, y: fieldTopSpace - 15)
        let upGoalPoint4 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalWidth) / 2 + goalWidth, y: fieldTopSpace)
        let upPenaltyPoints = [upPenaltyAreaPoint1, upPenaltyAreaPoint2, upPenaltyAreaPoint3, upPenaltyAreaPoint4, upGoalAreaPoint1, upGoalAreaPoint2, upGoalAreaPoint3, upGoalAreaPoint4, upGoalPoint1, upGoalPoint2, upGoalPoint3, upGoalPoint4]
        context?.addLines(between: upPenaltyPoints)
        context?.drawPath(using: .stroke)
        //画上方点球点
        let upPenaltyMarkPoint = CGPoint(x: FIELD_LEFT_SPACE + fieldWidth / 2, y: fieldTopSpace + PENALTY_MARK_DEFAULT_DISTANCE * scale)
        context?.addArc(center: upPenaltyMarkPoint, radius: 1.5, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: false)
        context?.drawPath(using: .fillStroke)
        //画上方罚球弧
        context?.addArc(center: upPenaltyMarkPoint, radius: scale * PENALTY_ARC_DEFAULT_RADIUS, startAngle: 0.2 * CGFloat(Double.pi), endAngle: 0.8 * CGFloat(Double.pi), clockwise: false)
        context?.drawPath(using: .stroke)
        //画下方禁区和球门
        let downPenaltyAreaPoint1 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - penaltyAreaLength) / 2, y: fieldTopSpace + fieldLength)
        let downPenaltyAreaPoint2 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - penaltyAreaLength) / 2, y: fieldTopSpace + fieldLength - penaltyAreaWidth)
        let downPenaltyAreaPoint3 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - penaltyAreaLength) / 2 + penaltyAreaLength, y: fieldTopSpace + fieldLength - penaltyAreaWidth)
        let downPenaltyAreaPoint4 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - penaltyAreaLength) / 2 + penaltyAreaLength, y: fieldTopSpace + fieldLength)
        let downGoalAreaPoint1 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalAreaLength) / 2 + goalAreaLength, y: fieldTopSpace + fieldLength)
        let downGoalAreaPoint2 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalAreaLength) / 2 + goalAreaLength, y: fieldTopSpace + fieldLength - goalAreaWidth)
        let downGoalAreaPoint3 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalAreaLength) / 2, y: fieldTopSpace + fieldLength - goalAreaWidth)
        let downGoalAreaPoint4 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalAreaLength) / 2, y: fieldTopSpace + fieldLength)
        let downGoalPoint1 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalWidth) / 2, y: fieldTopSpace + fieldLength)
        let downGoalPoint2 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalWidth) / 2, y: fieldTopSpace + fieldLength + 15)
        let downGoalPoint3 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalWidth) / 2 + goalWidth, y: fieldTopSpace + fieldLength + 15)
        let downGoalPoint4 = CGPoint(x: FIELD_LEFT_SPACE + (fieldWidth - goalWidth) / 2 + goalWidth, y: fieldTopSpace + fieldLength)
        let downPenaltyPoints = [downPenaltyAreaPoint1, downPenaltyAreaPoint2, downPenaltyAreaPoint3, downPenaltyAreaPoint4, downGoalAreaPoint1, downGoalAreaPoint2, downGoalAreaPoint3, downGoalAreaPoint4, downGoalPoint1, downGoalPoint2, downGoalPoint3, downGoalPoint4]
        context?.addLines(between: downPenaltyPoints)
        context?.drawPath(using: .stroke)
        //画下方点球点
        let downPenaltyMarkPoint = CGPoint(x: FIELD_LEFT_SPACE + fieldWidth / 2, y: fieldTopSpace + fieldLength - PENALTY_MARK_DEFAULT_DISTANCE * scale)
        context?.addArc(center: downPenaltyMarkPoint, radius: 1.5, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: false)
        context?.drawPath(using: .fillStroke)
        //画下方罚球弧
        context?.addArc(center: downPenaltyMarkPoint, radius: scale * PENALTY_ARC_DEFAULT_RADIUS, startAngle: 1.2 * CGFloat(Double.pi), endAngle: 1.8 * CGFloat(Double.pi), clockwise: false)
        context?.drawPath(using: .stroke)
    }
    
}
