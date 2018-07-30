//
//  REMobileAppApiVC.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/30.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class REMobileAppApiListController: FPBaseTableViewController {

	var function: String = ""
	var jsonParams: String = ""
	var model: REServiceModel = REServiceModel()
	
	var dataSource: FPTableDataSource!
	var data: [String] = REServiceFunction.functionList()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.title = "MobileApi"
		self.configureTableView()
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
	
	//MARK: - UITableViewDelegate
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return FPTableViewCell.cellHeight()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		function = data[indexPath.row]
		
		if data[indexPath.row] == REServiceFunction.getNewAmapListData.rawValue {
			jsonParams = "16819fc29bbd0ec50afeddbc6c21aeff"
		} else {
			model.FModuleId = "3093"
			jsonParams = model.jsonParams().jm_encryptUseDes(key: "02adfd5a", iv: "02adfd5a") ?? ""
		}
		
		performSegue(withIdentifier: "PushToMobileResult", sender: nil)
	}
	
	//MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? REMobileApiResultViewController {
			vc.function = function
			vc.jsonParams = jsonParams
		}
	}
}
