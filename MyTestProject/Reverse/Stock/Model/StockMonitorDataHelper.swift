//
//  StockMonitorDataHelper.swift
//  StockModule
//
//  Created by iblue on 2021/1/19.
//

import UIKit

public class StockMonitorDataHelper: NSObject {
    public static let sharedInstance = StockMonitorDataHelper()
    
    public var stockObjects: [ORMMonitorStockObject] = [ORMMonitorStockObject]()
    
    public override init() {
        super.init()
        loadDataBase()
    }
    
    //MARK: Load data
    func loadDataBase() {
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let stockPath = "\(documentDir)/Stocks"
        
        if FileManager.default.fileExists(atPath: stockPath) == false {
            try? FileManager.default.createDirectory(atPath: stockPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let dbPath = "\(stockPath)/Data.db"
        ORMStockDBHelper.sharedInstance.loadDB(filePath: dbPath)
        
        //加载表数据 
        loadStocks()
    }
    
    func loadStocks() {
        stockObjects.removeAll()
        let list = ORMStockDBHelper.sharedInstance.loadMonitorStocks()
        stockObjects.append(contentsOf: list)
    }
    
    //MARK: Insert/delete/update
    func insertStock(object: ORMMonitorStockObject) {
        ORMStockDBHelper.sharedInstance.insertMonitorStock(stock: object) { (result) in
            print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::insertNumber result: \(result)")
        }
    }
}
