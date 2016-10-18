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


class FPRoomGridInfo: NSObject {
    var gridType: FPRoomGirdType
    var gridState: FPRoomGridState
    var number: Int
    
    override init() {
        self.gridType = .Room
        self.gridState = .Normal
        self.number = 1
    }
}
