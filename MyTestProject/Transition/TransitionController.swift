//
//  TransitionController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/11.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class TransitionController: FPBaseController,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: FPTableDataSource!
    var data: Dictionary<String,String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = ["ViewTransition" : "PushToViewTransition"]
        self.configureTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView(){
        let identifier = FPTableViewCell.cellIdentifier()
        
        let allKeys = Array(data.keys)
        dataSource = FPTableDataSource.init(cellItems: allKeys, cellIdentifier: identifier, configureCell: {(cell, item) in
            let testCell = cell as! FPTableViewCell
            testCell.configureForCell(item)
        })
        
        tableView.registerClass(FPTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension TransitionController{
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FPTableViewCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let allValues = Array(data.values) as Array<String>
        if indexPath.row < allValues.count {
            let pushSegue = allValues[indexPath.row]
            self.performSegueWithIdentifier(pushSegue, sender: nil)
        }
    }
}