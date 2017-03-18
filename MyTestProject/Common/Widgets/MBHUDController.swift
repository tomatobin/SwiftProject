//
//  MBHUDController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/19.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit
import MBProgressHUD

class MBHUDController: FPBaseController,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: FPTableDataSource!
    var data: Dictionary<String,Selector>!
    var timer: Timer?
    var progress = Float(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerProcess), userInfo: nil, repeats: true)
        timer?.fireDate = Date.distantFuture
        
        data = ["Show Gif" : #selector(showGifLoading),
                "Show Message": #selector(showTxtHud),
                "Show Wating Normal": #selector(showWatingNormal),
                "Show Wating Determinate": #selector(showWatingDeterminate),
                "Show Wating AnnularDeterminate": #selector(showWatingNormalAnnularDeterminate),
                "Show Wating DeterminateHorizontalBar": #selector(showWatingDeterminateHorizontalBar)]
        
        self.configureTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func initNaviRightItemFromButton() -> UIButton? {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 44)
        button.setTitle("Dismiss", for: UIControlState())
        button.setTitleColor(UIColor.fp_mainRedColor(), for: UIControlState())
        button.addTarget(self, action: #selector(dismissHud), for: .touchUpInside)
        return button
    }
    
    func configureTableView(){
        let identifier = FPTableViewCell.cellIdentifier()
        
        let allKeys = Array(data.keys)
        dataSource = FPTableDataSource.init(cellItems: allKeys as Array<AnyObject>, cellIdentifier: identifier, configureCell: {(cell, item) in
            let testCell = cell as! FPTableViewCell
            testCell.configureForCell(item: item)
        })
        
        tableView.register(FPTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func dismissHud() {
        self.timer?.fireDate = Date.distantFuture
        FPHudUtility.hideGifLoading()
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    func showGifLoading() {
        let hud = FPHudUtility.showGifLoading(self.view, gifName: "Loading_rabbit") //不可以添加gif后缀
        hud.hide(true, afterDelay: 20.0)
    }
    
    func showTxtHud() {
        FPHudUtility.showMessage("Requesting...")
    }
    
    func showWatingNormal() {
        self.showWating(.indeterminate)
    }
    
    func showWatingDeterminate() {
        self.showWating(.determinate)
    }
    
    func showWatingNormalAnnularDeterminate() {
        self.showWating(.annularDeterminate)
    }
    
    func showWatingDeterminateHorizontalBar() {
        self.showWating(.determinateHorizontalBar)
    }
    
    func showWating(_ hudMode: MBProgressHUDMode) {
        self.progress = 0
        self.timer?.fireDate = Date.distantPast
        let hud = FPHudUtility.showWaitingHud(self.view)
        hud.yOffset = -Float(FP_NAVI_HEIGHT)
    }
    
    //MARK: Timer
    func timerProcess(_ timer: Timer) {
        self.progress += 0.025
        FPHudUtility.updateProgressHud(self.progress)
        
        if self.progress >= 1 {
            self.timer?.fireDate = Date.distantFuture
            self.dismissHud()
        }
    }
}

extension MBHUDController{
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FPTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let values = Array(data.values)
        let selector = values[indexPath.row] as Selector
        self.perform(selector)
    }
}
