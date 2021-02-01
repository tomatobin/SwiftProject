//
//  ORMStockDBHelper.swift
//  StockModule
//
//  Created by iblue on 2021/1/19.
//

import UIKit
import WCDBSwift

struct ORMTableName {
    /// 数据表
    static let stocks = "Stocks"
}

public class ORMStockDBHelper: NSObject {
    public static let sharedInstance = ORMStockDBHelper()
    
    public var database: Database?
    
    public func loadDB(filePath: String) {
        //加载数据库
        database = Database(withPath: filePath)
        
        //加载表
        loadTables()
    }
    
    func loadTables() {
        try? database?.create(table: ORMTableName.stocks, of: ORMMonitorStockObject.self)
    }
    
    // MARK: Table Operation
    public func insertMonitorStock(stock: ORMMonitorStockObject, completion: ((_ isSucceed: Bool)->())?) {
        do {
            try database?.insertOrReplace(objects: stock, intoTable: ORMTableName.stocks)
            completion?(true)
        } catch {
            print("❌❌❌ \(Date()) \(NSStringFromClass(self.classForCoder)):: Insert random number failed...")
            completion?(false)
        }
    }
    
    // MARK: Load
    public func loadMonitorStock(code: String) -> ORMMonitorStockObject? {
        var stock: ORMMonitorStockObject? = nil
        do {
            stock = try self.database?.getObject(on: ORMMonitorStockObject.Properties.all, fromTable: ORMTableName.stocks, where: ORMMonitorStockObject.Properties.code == code)
        } catch {
            print("❌❌❌ \(Date()) \(NSStringFromClass(self.classForCoder)):: loadDeviceObject deviceId")
        }
        
        return stock
    }
    
    public func loadMonitorStocks(count: Int? = 20) -> [ORMMonitorStockObject] {
        var stockList = [ORMMonitorStockObject]()
        do {
            let limit: Limit? = count ?? nil
            if let objects: [ORMMonitorStockObject] = try database?.getObjects(on: ORMMonitorStockObject.Properties.all,
                                                                              fromTable: ORMTableName.stocks,
                                                                              limit: limit) {
                stockList.append(contentsOf: objects)
            }
        } catch {
            print("❌❌❌ \(Date()) \(NSStringFromClass(self.classForCoder)):: Load number list failed...")
        }
        
        return stockList
    }
}
