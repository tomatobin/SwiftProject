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

    private var cellItems: Array<AnyObject>?
    private var cellIdentifier: String?
    private var configureCell: FPConfigureTableCellBlock?
    
    init(cellItems: Array<AnyObject>, cellIdentifier: String, configureCell: FPConfigureTableCellBlock) {
        super.init()
        self.cellItems = cellItems
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath)->AnyObject{
        return self.cellItems![indexPath.row]
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellItems!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier!, forIndexPath: indexPath) as UITableViewCell
        
        configureCell!(cell, self.cellItems![indexPath.row])
        return cell
    }
}
