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
	
	private var itemNumberTxt: LCTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.title = "MobileApi"
		self.configureTableView()
		self.setupItemNumberView()
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
	
	func setupItemNumberView() {
		let headerView = UIView(frame: CGRect(x: 0, y: -50, width: view.bounds.width, height: 50))
		tableView.tableHeaderView = headerView
		
		let label = UILabel()
		label.text = "ItemNumber:"
		headerView.addSubview(label)
		
		itemNumberTxt = LCTextField()
		itemNumberTxt.delegate = self
		itemNumberTxt.clearButtonMode = .whileEditing
		itemNumberTxt.lc_setInputRule(withRegEx: "[0-9]", andInputLength: 10)
		itemNumberTxt.placeholder = "eg:10651"
		headerView.addSubview(itemNumberTxt)
	
		label.snp.makeConstraints { (make) in
			make.left.equalTo(headerView).offset(15)
			make.top.equalTo(headerView).offset(15)
		}
		
		itemNumberTxt.snp.makeConstraints { (make) in
			make.left.equalTo(label.snp.right).offset(5)
			make.width.equalTo(120)
			make.centerY.equalTo(label).offset(1.5)
		}
		
		itemNumberTxt.text = loadItemNumber()
	}
	
	//MARK: - UITableViewDelegate
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return FPTableViewCell.cellHeight()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		function = data[indexPath.row]
		itemNumberTxt.resignFirstResponder()
		saveItemNumber(itemNumber: itemNumberTxt.text)
		
		if data[indexPath.row] == REServiceFunction.getNewAmapListData.rawValue {
			jsonParams = "16819fc29bbd0ec50afeddbc6c21aeff"
		} else {
			model.FModuleId = "3093"
			model.FItemNumber = itemNumberTxt.text ?? ""
			let jsonParam = model.jsonParams()
			jsonParams = jsonParam.jm_encryptUseDes(key: "02adfd5a", iv: "02adfd5a") ?? ""
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

extension REMobileAppApiListController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		saveItemNumber(itemNumber: textField.text)
		return true
	}
}

extension REMobileAppApiListController {
	
	func loadItemNumber() -> String? {
		return UserDefaults.standard.string(forKey: "ReItemNumber")
	}
	
	func saveItemNumber(itemNumber: String?) {
		UserDefaults.standard.setValue(itemNumber, forKey: "ReItemNumber")
		UserDefaults.standard.synchronize()
	}
}
