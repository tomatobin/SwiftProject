//
//  StockConfigInfo.swift
//  MyTestProject
//
//  Created by iblue on 2020/12/4.
//  Copyright © 2020 iblue. All rights reserved.
//

import UIKit

class StockConfigManager: NSObject {
    
    static let sharedInstance = StockConfigManager()
    
    var code: String = ""
    
    /// 2236买入标准21.2
    var minPrice: Double = 0
    
    var maxPrice: Double = 0
    
    var time: TimeInterval = 8.97
    
    override init () {
        super.init()
        
        loadConfig()
    }
    
    func saveConfig() {
        UserDefaults.standard.setValue(minPrice, forKey: "StockConfig_MinPrice")
        UserDefaults.standard.setValue(maxPrice, forKey: "StockConfig_MaxPrice")
        UserDefaults.standard.setValue(time, forKey: "StockConfig_Time")
        UserDefaults.standard.setValue(code, forKey: "StockConfig_Code")
        UserDefaults.standard.synchronize()
    }
    
    func loadConfig() {
        if let cachedMin = UserDefaults.standard.value(forKey: "StockConfig_MinPrice") as? Double {
            minPrice = cachedMin
        }
        
        if let cachedMax = UserDefaults.standard.value(forKey: "StockConfig_MaxPrice") as? Double {
            maxPrice = cachedMax
        }
        
        if let cachedCode = UserDefaults.standard.value(forKey: "StockConfig_Code") as? String {
            code = cachedCode
        }
        
        if let cachedTime = UserDefaults.standard.value(forKey: "StockConfig_Time") as? Double {
            time = cachedTime
        }
    }
}
