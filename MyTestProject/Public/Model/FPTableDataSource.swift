//
//  FPTableDataSource.swift
//  FPSwift
//
//  Created by iblue on 16/6/7.
//  Copyright © 2016年 iblue. All rights reserved.
//  UITableView的数据源DataSource封装

import UIKit

typealias FPConfigureTableCellBlock = (UITableViewCell, AnyObject)->Void

class FPTableDataSource: NSObject,UITableViewDataSource {

    fileprivate var cellItems: Array<AnyObject>?
    fileprivate var cellIdentifier: String?
    fileprivate var configureCell: FPConfigureTableCellBlock?
    
    init(cellItems: Array<AnyObject>, cellIdentifier: String, configureCell: @escaping FPConfigureTableCellBlock) {
        super.init()
        self.cellItems = cellItems
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath)->AnyObject{
        return self.cellItems![indexPath.row]
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellItems!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier!, for: indexPath) as UITableViewCell
        
        configureCell!(cell, self.cellItems![indexPath.row])
        return cell
    }
}
