//
//  FPRoomGridInfo.swift
//  MyTestProject
//
//  Created by jiangbin on 16/10/18.
//  Copyright © 2016年 iblue. All rights reserved.
//

enum FPRoomGirdType {
    case Room
    case Elevator
}

enum FPRoomGridState {
    case Normal
    case Selected
    case Disabled
}

enum FPRoomGridDirection {
    case Up
    case Down
}

class FPRoomGridInfo: NSObject {
    var gridType: FPRoomGirdType
    var gridState: FPRoomGridState
    var gridDirection: FPRoomGridDirection
    var number: Int
    
    override init() {
        self.gridType = .Room
        self.gridState = .Normal
        self.gridDirection = .Down
        self.number = 1
    }
    
    /**
     Room类型对应的图片
     
     - returns: 图片
     */
    func image() -> UIImage {
        
        var imageName = "room_down_unselect"
        if gridDirection == .Up {
            switch gridState {
            case .Normal:
                imageName = "room_down_unselect"
            case .Selected:
                imageName = "room_down_select"
            case .Disabled:
                imageName = "room_down_disable"
            }
        } else {
            switch gridState {
            case .Normal:
                imageName = "room_up_unselect"
            case .Selected:
                imageName = "room_up_select"
            case .Disabled:
                imageName = "room_up_disable"
            }
        }
        
        return UIImage(named: imageName)!
    }
    
    /**
     Room类型对应的文字
     
     - returns: 文字
     */
    func text() -> String {
        if gridType == .Room {
            return String(format: "%02d", number)
        }
        
        return "电\n梯"
    }
}
