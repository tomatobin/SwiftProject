//
//  ORMStockMonitorInfo.swift
//  StockModule
//
//  Created by iblue on 2021/1/19.
//

import UIKit
import WCDBSwift

public class ORMMonitorStockObject: NSObject,TableCodable {
    /// 代码
    public var code: String = ""
    
    /// 名称
    public var name: String = ""
    
    public var minPrice: Double = 0
    
    public var maxPrice: Double = 0
    
    public var buyPrice: Double = 0
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = ORMMonitorStockObject
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case code
        case name
        case minPrice
        case maxPrice
        
        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                code: ColumnConstraintBinding(isPrimary: true, onConflict: .replace, isUnique: true),
            ]
        }
    }
}
