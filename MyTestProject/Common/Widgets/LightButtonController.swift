//
//  LightButtonController.swift
//  MyTestProject
//
//  Created by iblue on 2018/6/12.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class LightButtonController: FPBaseController,UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	var dataSource: FPTableDataSource!
	var data: [DHWifiConnectFailureType] = [.tp1, .tp1s, .g1, .k5, .overseasA, .overseasC, .overseasDoorbell, .common]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Widgets"
		self.configureTableView()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func configureTableView(){
		let identifier = FPTableViewCell.cellIdentifier()
		
		var dataArray = [FPTableViewCellData]()
		for type in data {
			let celldata = FPTableViewCellData(title: type.rawValue, imageName: nil, detail: nil, type: .normal)
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
	}
}


extension LightButtonController{
	//MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return FPTableViewCell.cellHeight()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		self.performSegue(withIdentifier: "PushToFailure", sender: data[indexPath.row])
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let controller = segue.destination as? LightFailureController {
			controller.failureType = sender as! DHWifiConnectFailureType
		}
	}
}
