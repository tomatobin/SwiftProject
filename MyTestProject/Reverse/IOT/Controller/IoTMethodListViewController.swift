//
//  IoTMethodListViewController.swift
//  MyTestProject
//
//  Created by iblue on 2020/6/23.
//  Copyright © 2020 iblue. All rights reserved.
//

import UIKit

class IoTMethodListViewController: FPBaseTableViewController {

    var function: String = ""
    var params: [String: Any] = [String: Any]()
    
    var dataSource: FPTableDataSource!
    var data: [String] = ["/things/v1/wireless/wifi/list", "/things/v1/wireless/wifi/set"]
    
    private var hostTxf: LCTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "MobileApi"
        self.configureTableView()
        self.setupHostView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        let identifier = FPTableViewCell.cellIdentifier()
        
        var dataArray = [FPTableViewCellData]()
        for string in data {
            let celldata = FPTableViewCellData(title: string, imageName: nil, detail: nil, type: .normal)
            dataArray.append(celldata)
        }
        
        dataSource = FPTableDataSource.init(cellItems: dataArray, cellIdentifier: identifier, configureCell: {(cell, item) in
            let testCell = cell as! FPTableViewCell
            testCell.configureForCell(item: item)
        })
        
        tableView.register(FPTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
        tableView.fp_setExtraRowsHidden()
    }
    
    func setupHostView() {
        let headerView = UIView(frame: CGRect(x: 0, y: -50, width: view.bounds.width, height: 50))
        tableView.tableHeaderView = headerView
        
        let label = UILabel()
        label.text = "Host:"
        headerView.addSubview(label)
        
        hostTxf = LCTextField()
        hostTxf.delegate = self
        hostTxf.clearButtonMode = .whileEditing
        hostTxf.placeholder = "http://192.168.0.108:39000"
        headerView.addSubview(hostTxf)
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(headerView).offset(15)
            make.top.equalTo(headerView).offset(15)
        }
        
        hostTxf.snp.makeConstraints { (make) in
            make.left.equalTo(label.snp.right).offset(10)
            make.right.equalTo(self.view).offset(-15)
            make.centerY.equalTo(label).offset(1.5)
        }
        
        if let savedHost = loadSavedHost(), savedHost.count > 0 {
            hostTxf.text = savedHost
        } else {
            hostTxf.text = "http://192.168.0.108:39000"
        }
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FPTableViewCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        function = data[indexPath.row]
        hostTxf.resignFirstResponder()
        saveHost(host: hostTxf.text)
        
        if indexPath.row == 1 {
            params["SSID"] = "aruba-test-5F"
            params["BSSID"] = "04:bd:88:a1:fa:e0"
            params["Encryption"] = "6"
            params["password"] = "dahua2020"
        } else {
            params.removeAll()
        }
        
        performSegue(withIdentifier: "PushToMobileResult", sender: nil)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? IoTApiResultViewController {
            vc.function = function
            vc.host = hostTxf.text ?? ""
            vc.dicParams = params
        }
    }
}

extension IoTMethodListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveHost(host: textField.text)
        return true
    }
}

extension IoTMethodListViewController {
    
    func loadSavedHost() -> String? {
        return UserDefaults.standard.string(forKey: "IOTHost")
    }
    
    func saveHost(host: String?) {
        UserDefaults.standard.setValue(host, forKey: "IOTHost")
        UserDefaults.standard.synchronize()
    }
}
