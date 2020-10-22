//
//  StockInfo.swift
//  MyTestProject
//
//  Created by iblue on 2020/10/19.
//  Copyright © 2020 iblue. All rights reserved.
//

import UIKit

/// 状态序号
enum StockStateIndex: Int {
    case name = 0
    case open = 1
    case yesterdayClose = 2
    case current = 3
    case max = 4
    case min = 5
    case average = 29
    case date = 30
    case time = 31
    case enumEndFlag = 32
}

class StockInfo: NSObject {

    var name: String = ""
    
    var code: String = ""
    
    var currentPrice: String = ""
    
    var openPrice: String = ""
    
    var yesterdayClosePrice: String = ""
    
    var maxPrice: String = ""
    
    var minPrice: String = ""
    
    var averagePrice: String = ""
    
    var date: String = ""
    
    var time: String = ""
    
    var comparePercent: Double = 0
    
    var comparePrice: Double = 0
    
    var localizedComparePrice: String = ""
    
    override var description: String {
        let desc = "\(date) \(time)::\(code) \(name):  \(currentPrice)  [\(averagePrice) (\(minPrice) \(maxPrice))]"
        return desc
    }
    
    init(string: String) {
        super.init()
        let object = string.replacingOccurrences(of: "\n", with: "")
        let datas = object.components(separatedBy: ",")
        guard datas.count >= StockStateIndex.enumEndFlag.rawValue else {
            return
        }
    
        let fullname = datas[StockStateIndex.name.rawValue]
        if let endIndex = fullname.firstIndex(of: "=") {
            name = String(fullname.suffix(from: endIndex )).replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "=", with: "")
            let prefix = String(fullname.prefix(upTo: endIndex))
            code = String(prefix.suffix(8))
            
            //脱敏显示
            name.removeLast()
            name.removeLast()
            name.removeLast()
            name.append("*")
            name.append("*")
            name.append("*")
        }
                            
        currentPrice = datas[StockStateIndex.current.rawValue]
        openPrice = datas[StockStateIndex.open.rawValue]
        yesterdayClosePrice = datas[StockStateIndex.yesterdayClose.rawValue]
        maxPrice = datas[StockStateIndex.max.rawValue]
        minPrice = datas[StockStateIndex.min.rawValue]
        averagePrice = datas[StockStateIndex.average.rawValue]
        date = datas[StockStateIndex.date.rawValue]
        time = datas[StockStateIndex.time.rawValue]
        
        //去除最后一位数
        currentPrice = fixPrice(price: currentPrice)
        openPrice = fixPrice(price: openPrice)
        yesterdayClosePrice = fixPrice(price: yesterdayClosePrice)
        maxPrice = fixPrice(price: maxPrice)
        minPrice = fixPrice(price: minPrice)
        averagePrice = fixPrice(price: averagePrice)
        
        //计算
        calcuPrice()
        
        print("🍎🍎🍎 \(date) \(time) \(name):: current:\(currentPrice) \(localizedComparePrice) open:\(openPrice), yesterday:\(yesterdayClosePrice), [\(averagePrice) (\(minPrice), \(maxPrice))] ")
    }
    
    func fixPrice(price: String) -> String {
        if let last = price.split(separator: ".").last, last.count > 2 {
            var fixPrice = price
            fixPrice.removeLast()
            return fixPrice
        }
        
        return price
    }
    
    func calcuPrice() {
        let current = Double(currentPrice) ?? 0
        if let yestClose = Double(yesterdayClosePrice) {
            comparePrice = current - yestClose
            comparePercent = (current - yestClose) / yestClose
            let prefix = comparePrice > 0 ? "+" : ""
            localizedComparePrice = String(format: "\(prefix)%0.2f%%", comparePercent * 100)
        }
    }
}
