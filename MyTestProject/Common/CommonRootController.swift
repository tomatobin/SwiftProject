//
//  RootController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/6/30.
//  Copyright © 2016年 iblue. All rights reserved.
//  常用的界面

import UIKit

class CommonRootController: FPBaseController,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: FPTableDataSource!
    var data: Dictionary<String,String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        data = ["AVFoundation": "PushToAVFoundation", "AudioToolbox" : "PushToAudioToolbox",
                "Transition": "PushToTransition", "Widgets": "PushToWidgets"]
        self.title = "常用"
        self.configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView(){
        let identifier = FPTableViewCell.cellIdentifier()
        
        var dataArray = [FPTableViewCellData]()
        for key in Array(data.keys) {
            let celldata = FPTableViewCellData(title: key, imageName: nil, detail: nil, type: .normal)
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
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return FPTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let allValues = Array(data.values) as Array<String>
        if indexPath.row < allValues.count {
            let pushSegue = allValues[indexPath.row]
            self.performSegue(withIdentifier: pushSegue, sender: nil)
        }
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
}
