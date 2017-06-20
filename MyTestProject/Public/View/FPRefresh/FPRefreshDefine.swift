//
//  FPRefreshConst.swift
//  MyTestProject
//
//  Created by jiangbin on 2017/6/19.
//  Copyright © 2017年 iblue. All rights reserved.
//

import Foundation

let FPRefreshRuntimeKey = UnsafeRawPointer(bitPattern: "ComponentKey".hashValue)!
let FPRefreshKeyPathContentOffset = "contentOffset"
let FPRefreshKeyPathContentInset = "contentInset"
let FPRefreshKeyPathContentSize = "contentSize"

let FPRefreshSlowAnimationDuration = 0.4
let FPRefreshFastAnimationDuration = 0.25

/// 控件刷新状态
///
/// - idle: 普通空闲控件刷新状态
/// - pulling: 松开就可以刷新的状态
/// - refreshing: 正在刷新
enum FPRefreshState: Int {
    case idle
    case pulling
    case refreshing
}

/// 进入刷新状态的回调
typealias FPRefreshComponentRefreshingBlcok = () -> Void
