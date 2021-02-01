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
    
    var openLog: Bool = true
    
    /// 是否使用颜色标记
    var useColor: Bool = false

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
    
    var localizedComparePricePercent: String = ""
    
    override var description: String {
        let desc = "\(time)::\(code) \(name):  \(currentPrice) \(localizedComparePricePercent) \(localizedComparePrice) | \(openPrice) [ \(averagePrice) (\(minPrice) \(maxPrice))]"
        return desc
    }
    
    init(string: String, isShowColor: Bool = true, isShowLog: Bool = true) {
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
         
        openLog = isShowLog
        useColor = isShowColor
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
        
        if openLog {
            print("🍎🍎🍎 \(date) \(time) \(name):: \(currentPrice) \(localizedComparePricePercent) \(localizedComparePrice) [open:\(openPrice), yesterday:\(yesterdayClosePrice), \(averagePrice) (\(minPrice), \(maxPrice))] ")
        } else {
            print("🍎🍎🍎 \(date) \(time) :: \(localizedComparePrice) p2p delay... testing...[\(currentPrice) (\(minPrice), \(maxPrice))]")
        }
    }
    
    func fixPrice(price: String) -> String {
        //5以下显示原始数据
        if let doublePrice = Double(price), doublePrice < 5.0 {
            return price
        }
        
        //显示两位即可
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
            comparePrice = current > 0 ? current - yestClose : 0
            comparePercent = comparePrice / yestClose
            var prefixColor = ""
            if useColor {
                prefixColor = comparePrice >= 0 ? "🔴" : "💹"
            }
            
            let prefix = comparePrice > 0 ? "+" : ""
            localizedComparePricePercent = String(format: "\(prefixColor)\(prefix)%0.2f%%", comparePercent * 100)
            localizedComparePrice = String(format: "\(prefixColor)\(prefix)%0.2f", comparePrice)
        }
    }
}
