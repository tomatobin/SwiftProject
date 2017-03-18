//
//  FPNetworkingMonitor.swift
//  FPSwift
//
//  Created by iblue on 16/7/3.
//  Copyright © 2016年 iblue. All rights reserved.
//  网络状态监测类

import Alamofire

class FPNetworkingMonitor: NSObject {

    var status: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    
    //单例实现
    static let sharedInstance: FPNetworkingMonitor = FPNetworkingMonitor()
    
    func startMonitor(){
        let networkManager = NetworkReachabilityManager()
        networkManager?.startListening()
        networkManager?.listener = { status in
            ColorLog.green("Network changed:\(self.descriptio(status))")
            self.status = status
        }
    }
    
    fileprivate override init() {
        ColorLog.cyan("\(NSStringFromClass(FPNetworkingMonitor.self)) init")
        self.status = .unknown
    }
    
    fileprivate func descriptio(_ status: NetworkReachabilityManager.NetworkReachabilityStatus) -> String{
        switch status {
        case .notReachable:
            return "Not Reachable"
        case .reachable(.ethernetOrWiFi):
            return "Wifi"
        case .reachable(.wwan):
            return "WWan"
        default:
            return "Unknow"
        }
    }
}
