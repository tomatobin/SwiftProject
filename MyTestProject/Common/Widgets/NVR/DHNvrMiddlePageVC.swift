//
//  DHNvrMiddlePageVC.swift
//  MyTestProject
//
//  Created by iblue on 2018/9/3.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

struct DHNvrMiddlePageVcConfig {
	static let topHeight: CGFloat = 64
	static let bgHeight: CGFloat = 120 + topHeight
	static let headerHeight: CGFloat = 140
	static let cornerRadius: CGFloat = 8
}

class DHNvrMiddlePageVC: FPBaseController,UITableViewDelegate,UITableViewDataSource {
	
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var tableView: UITableView!
	var bgImageView: UIImageView!
	
	var channelList: [String] = ["NVR-01", "NVR-02", "NVR-03", "NVR-04", "NVR-05", "NVR-06", "NVR-07", "NVR-08"]
	
	var operationTypes: [DHNvrOperationItemType] = [.ignoreAlarm, .talk, .siren]
	
	var isExpaned: Bool = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		configureTableViewStyle()
		configTopView()
		configBgImageView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
	func configBgImageView() {
		bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: DHNvrMiddlePageVcConfig.bgHeight))
		bgImageView.image = UIImage(named: "common_bg")
		bgImageView.contentMode = .scaleAspectFill
		view.insertSubview(bgImageView, belowSubview: tableView)
		view.bringSubview(toFront: topView)
	}
	
	func configTopView() {
		topView.backgroundColor = UIColor.clear
	}
	
	func configureTableViewStyle() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = UIColor.clear
		
		tableView.layer.cornerRadius = DHNvrMiddlePageVcConfig.cornerRadius
		tableView.layer.masksToBounds = true
		
		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: DHNvrMiddlePageVcConfig.bgHeight))
		headerView.backgroundColor = UIColor.clear
		tableView.tableHeaderView = headerView
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func onLeftAction(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	//MARK: UITableViewDelegate
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return DHNvrMidTipCell.height()
		}
		
		return isExpaned ? DHNvrMiddleChannelCell.height() :  0
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if operationTypes.count == 0 {
			return 0
		}
		
		return DHNvrMiddlePageVcConfig.headerHeight
	}
	
	func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.row == 0 ? false : true
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
	}
	
	//MARK: UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return channelList.count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell
		if indexPath.row == 0 {
			cell = tableView.dequeueReusableCell(withIdentifier: DHNvrMidTipCell.identifier(), for: indexPath)
			let tipCell = cell as! DHNvrMidTipCell
			tipCell.countLabel.text = "Camera" + "(\(channelList.count))"
			//【*】NVR不支持添加、管理
			tipCell.addButton.isHidden = true
			tipCell.editButton.isHidden = true
			tipCell.expand = { [unowned self] in
				self.isExpaned = !self.isExpaned
				tableView.reloadSections([0], with: .none)
			}
			
			tipCell.edit = {[unowned self] in
				print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::\(self.isExpaned)")
				tableView.isEditing = !tableView.isEditing
			}
			
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: DHNvrMiddleChannelCell.identifier(), for: indexPath)
			let chnCell = cell as! DHNvrMiddleChannelCell
			chnCell.nameLabel.text = channelList[indexPath.row - 1]
			chnCell.detailLabel.text = "动检已开启"
			chnCell.accessoryType = .disclosureIndicator
		}
		cell.selectionStyle = .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if operationTypes.count == 0 {
			return nil
		}
		
		let headerView = DHNvrOperationView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: DHNvrMiddlePageVcConfig.headerHeight))
		headerView.backgroundColor = UIColor.white
		headerView.addCornerRadius(radius: DHNvrMiddlePageVcConfig.cornerRadius)
		headerView.setup(types: operationTypes)
		
		return headerView
	}
	
	@objc func onIgnoreAction() {
		print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: Ignore clicked...")
	}
}

extension DHNvrMiddlePageVC {
	//MARK: ScrollViewDelaget
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let yOffset = scrollView.contentOffset.y
		//		if yOffset <= 0 {
		//			bgImageView.frame = CGRect(x: 0, y: yOffset, width: bgImageView.frame.width, height: 264-yOffset)
		//		}
		
		if yOffset >= 0 {
			let compareHeight = DHNvrMiddlePageVcConfig.bgHeight - DHNvrMiddlePageVcConfig.topHeight
			bgImageView.fp_y = yOffset > compareHeight ? -compareHeight  : -yOffset
		} else {
			let compareHeight = DHNvrMiddlePageVcConfig.bgHeight
			let scale = (compareHeight - yOffset) / compareHeight
			let width = view.bounds.width
			bgImageView.frame = CGRect(x: -(width * scale - width)/2.0, y: 0, width: width * scale, height: scale * compareHeight)
		}
		
		//print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder))::Offset \(yOffset)")
	}
	
	func switchNaviItemStyle(style transparent: Bool) {
		//self.showIndicatorLine(showLine: !transparent)
	}
}

class DHNvrMiddleChannelCell: UITableViewCell {
	
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	
	class func identifier() -> String {
		return "DHNvrMiddleChannelCell"
	}
	
	class func height() -> CGFloat {
		return 80
	}
}

class DHNvrMidTipCell: UITableViewCell {
	
	var expand: (()->())?
	var add: (()->())?
	var edit: (()->())?
	
	@IBOutlet weak var countLabel: UILabel!
	@IBOutlet weak var expandButton: UIButton!
	@IBOutlet weak var addButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	
	class func identifier() -> String {
		return "DHNvrMidTipCell"
	}
	
	class func height() -> CGFloat {
		return 40
	}
	
	@IBAction func onAddAction(_ sender: Any) {
		add?()
	}
	
	@IBAction func onEditAction(_ sender: Any) {
		edit?()
	}
	
	@IBAction func onExpandAction(_ sender: Any) {
		expand?()
	}
}
