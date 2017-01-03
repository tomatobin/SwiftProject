//
//  FPRoomGridInfo.swift
//  MyTestProject
//
//  Created by jiangbin on 16/10/18.
//  Copyright © 2016年 iblue. All rights reserved.
//

enum FPRoomGirdType {
    case room
    case elevator
}

enum FPRoomGridState {
    case normal
    case selected
    case disabled
}

enum FPRoomGridDirection {
    case up
    case down
}

class FPRoomGridInfo: NSObject {
    var gridType: FPRoomGirdType
    var gridState: FPRoomGridState
    var gridDirection: FPRoomGridDirection
    var number: Int
    
    override init() {
        self.gridType = .room
        self.gridState = .normal
        self.gridDirection = .down
        self.number = 1
    }
    
    /**
     Room类型对应的图片
     
     - returns: 图片
     */
    func image() -> UIImage {
        
        var imageName = "room_down_unselect"
        if gridDirection == .up {
            switch gridState {
            case .normal:
                imageName = "room_down_unselect"
            case .selected:
                imageName = "room_down_select"
            case .disabled:
                imageName = "room_down_disable"
            }
        } else {
            switch gridState {
            case .normal:
                imageName = "room_up_unselect"
            case .selected:
                imageName = "room_up_select"
            case .disabled:
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
        if gridType == .room {
            return String(format: "%02d", number)
        }
        
        return "电\n梯"
    }
}
