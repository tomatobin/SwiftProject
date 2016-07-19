//
//  MBHUDController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/19.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class MBHUDController: FPBaseController,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: FPTableDataSource!
    var data: Dictionary<String,Selector>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = ["ShowGif" : #selector(showGifLoading)]
        self.configureTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func naviRightButton() -> UIButton? {
        let button = UIButton(type: .System)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 44)
        button.setTitle("Dismiss", forState: .Normal)
        button.setTitleColor(UIColor.fp_mainRedColor(), forState: .Normal)
        button.addTarget(self, action: #selector(dismissHud), forControlEvents: .TouchUpInside)
        return button
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
    
    func dismissHud() {
        FPHudUtility.hideGifLoading()
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func showGifLoading() {
        let hud = FPHudUtility.showGifLoading(self.view, gifName: "Loading_rabbit") //不可以添加gif后缀
        hud.hide(true, afterDelay: 20.0)
    }
}

extension MBHUDController{
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FPTableViewCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let values = Array(data.values)
        let selector = values[indexPath.row] as Selector
        self.performSelector(selector)
    }
}
