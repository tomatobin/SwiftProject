//
//  FilterController.swift
//  MyTestProject
//
//  Created by 江斌 on 16/12/21.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

enum FPReservationSection: Int {
    case payDate = 0    //付款时间
    case payTime = 1    //付款方式
    case payMode = 2    //支付方式
    case payAgreement = 3   //协议
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
        self.tableView.separatorStyle = .none
        self.tableView.register(FPTableViewCell.self, forCellReuseIdentifier: FPTableViewCell.cellIdentifier())
        self.tableView.register(FPFliterCell.self, forCellReuseIdentifier: FPFliterCell.cellIdentifier())
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 1
        switch FPReservationSection(rawValue: section)! {
        case .payDate:
            rows = 2
        case .payTime:
            rows = 3
        case .payMode:
            rows = 2
        default:
            rows = 1
        }
        return rows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch FPReservationSection(rawValue: indexPath.section)! {
        case .payDate:
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "FPTableViewCell", for: indexPath)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: FPFliterCell.cellIdentifier(), for: indexPath)
                let fliterCell = cell as! FPFliterCell
                fliterCell.configCell(["一季度", "半年", "一年"])
                fliterCell.clickBlock = { index in
                    print("Clicked index:\(index)")
                }
            }
            
        case .payTime:
            cell = tableView.dequeueReusableCell(withIdentifier: "FPTableViewCell", for: indexPath)
            self.configPayTimeCell(cell as! FPTableViewCell, indexPath: indexPath)
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "FPTableViewCell", for: indexPath)
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func configPayTimeCell(_ cell: FPTableViewCell, indexPath: IndexPath) {

    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            return 60
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
