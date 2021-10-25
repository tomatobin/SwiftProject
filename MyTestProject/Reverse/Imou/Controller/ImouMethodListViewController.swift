//
//  ImouMethodListViewController.swift
//  MyTestProject
//
//  Created by iblue on 2020/7/7.
//  Copyright © 2020 iblue. All rights reserved.
//

import UIKit

class ImouMethodListViewController: FPBaseTableViewController {

    var defaultHost: String = "https://app-testing-sz.easy4ipcloud.com:443" //"http://app-testing-sz.easy4ipcloud.com
    var function: String = ""
    var jsonData: Data?
    var headers: [String: String] = [String : String]()
    
    var dataSource: FPTableDataSource!
    var data: [ImouURI] = ImouURI.allURI()
    var model: ImouMethodListModel = ImouMethodListModel()
    
    private var hostTxf: LCTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "MobileApi"
        self.configureTableView()
        self.setupHostView()
        
        
        model.decode(sign: "t7W+h4q3J7+QPczd+VkdY0FRBiZroIsrYTEmugN2fnQ=")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        let identifier = FPTableViewCell.cellIdentifier()
        
        var dataArray = [FPTableViewCellData]()
        for method in data {
            let celldata = FPTableViewCellData(title: method.rawValue, imageName: nil, detail: nil, type: .normal)
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
        hostTxf.placeholder = defaultHost
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
            hostTxf.text = defaultHost
        }
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FPTableViewCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let method = data[indexPath.row]
        function = method.rawValue
        hostTxf.resignFirstResponder()
        saveHost(host: hostTxf.text)
        
        jsonData = model.body(uri: method)
        
        let username = "18958107580" // "617362485@qq.com"
        let pwdMd5 = "mobile888".fp_md5()
        headers = model.headers(uri: .getToken, username: "account\\\(username)", token: pwdMd5, body: jsonData)
        
        performSegue(withIdentifier: "PushToMobileResult", sender: nil)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? IoTApiResultViewController {
            vc.function = function
            vc.host = hostTxf.text ?? ""
            vc.jsonData = jsonData
            vc.headers = headers
        }
    }

}

extension ImouMethodListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveHost(host: textField.text)
        return true
    }
}

extension ImouMethodListViewController {
    
    func loadSavedHost() -> String? {
        return UserDefaults.standard.string(forKey: "ImouHost")
    }
    
    func saveHost(host: String?) {
        UserDefaults.standard.setValue(host, forKey: "ImouHost")
        UserDefaults.standard.synchronize()
    }
}
