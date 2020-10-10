//
//  FPReverseController.swift
//  MyTestProject
//
//  Created by iblue on 2017/7/4.
//  Copyright © 2017年 iblue. All rights reserved.
//

import UIKit

class FPReverseController: FPBaseTableViewController {

	var dataSource: FPTableDataSource!
	var data: Dictionary<String,String>!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        data = ["MobileApp": "PushToMobileApp", "IOT": "PushToIOT", "Imou": "PushToImou"]
		self.configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func configureTableView() {
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
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return FPTableViewCell.cellHeight()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let allValues = Array(data.values) as Array<String>
		if indexPath.row < allValues.count {
			let pushSegue = allValues[indexPath.row]
			let keys = Array(data.keys) as Array<String>
			self.performSegue(withIdentifier: pushSegue, sender: nil)
		}
	}
}
