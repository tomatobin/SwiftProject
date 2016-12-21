//
//  FilterController.swift
//  MyTestProject
//
//  Created by 江斌 on 16/12/21.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

enum FPReservationSection: Int {
    case PayDate = 0    //付款时间
    case PayTime = 1    //付款方式
    case PayMode = 2    //支付方式
    case PayAgreement = 3   //协议
}

class FliterController: FPBaseController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initUIWidgets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initUIWidgets() {
        self.tableView.backgroundColor = UIColor.fp_mainBgColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(FPTableViewCell.self, forCellReuseIdentifier: FPTableViewCell.cellIdentifier())
        self.tableView.registerClass(FPFliterCell.self, forCellReuseIdentifier: FPFliterCell.cellIdentifier())
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 1
        switch FPReservationSection(rawValue: section)! {
        case .PayDate:
            rows = 2
        case .PayTime:
            rows = 3
        case .PayMode:
            rows = 2
        default:
            rows = 1
        }
        return rows
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch FPReservationSection(rawValue: indexPath.section)! {
        case .PayDate:
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("FPTableViewCell", forIndexPath: indexPath)
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(FPFliterCell.cellIdentifier(), forIndexPath: indexPath)
                let fliterCell = cell as! FPFliterCell
                fliterCell.configCell(["一季度", "半年", "一年"])
                fliterCell.clickBlock = { index in
                    print("Clicked index:\(index)")
                }
            }
            
        case .PayTime:
            cell = tableView.dequeueReusableCellWithIdentifier("FPTableViewCell", forIndexPath: indexPath)
            self.configPayTimeCell(cell as! FPTableViewCell, indexPath: indexPath)
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("FPTableViewCell", forIndexPath: indexPath)
        }
        cell.selectionStyle = .None
        
        return cell
    }
    
    func configPayTimeCell(cell: FPTableViewCell, indexPath: NSIndexPath) {

    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            return 60
        }
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

class FPPayDateSelectCell: UITableViewCell {
    class func cellHeight() -> CGFloat {
        return 44
    }
    
    class func cellIdentifier() -> String {
        return "FPPayDateSelectCell"
    }
}

class FPPayTimeSelectCell: UITableViewCell {
    
    class func cellHeight() -> CGFloat {
        return 125
    }
    
    class func cellIdentifier() -> String {
        return "FPPayTimeSelectCell"
    }
}
