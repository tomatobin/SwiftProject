//
//  CityTableViewController.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/23.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class CityTableViewController: FPBaseTableViewController,CityVCProtocol {

	public var presenter: CityPresenter?
	
	public static func storyboardInstance() -> CityTableViewController {
		let storyboard = UIStoryboard(name: "MVP", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "CityTableViewController")
		return controller as! CityTableViewController
	}
	
	private var btnNaviRight: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        setupNaviRightItem()
		
		//无界面复用情况下，直接在内部创建Presenter
		/*
		presenter = CityPresenter()
		presenter?.cityView = self
		*/
		
		//有需要进行界面复用的情况下，需要在Module或者使用的地方，创建Presenter
		//参考 CommonRootController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func setupNaviRightItem() {
		btnNaviRight = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		btnNaviRight.contentHorizontalAlignment = .right
		btnNaviRight.setTitle("Refresh", for: .normal)
		btnNaviRight.setTitleColor(UIColor.lc_colorWithHexString("2c2c2c"), for: .normal)
		btnNaviRight.setTitleColor(UIColor.lightGray, for: .disabled)
		btnNaviRight.addTarget(self, action: #selector(onRefreshAction), for: .touchUpInside)
		let item = UIBarButtonItem(customView: btnNaviRight)
		self.navigationItem.rightBarButtonItem = item
	}
	
	@objc func onRefreshAction() {
		presenter?.refreshCityData()
	}
	
	// MARK: - Table view delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter?.didSelect(table: tableView, indexPath: indexPath)
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		return presenter?.numberOfSections() ?? 0
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.numberOfRows(section: section) ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
		presenter?.configure(cell: cell, indexPath: indexPath)
		return cell
	}
	
	//MARK: BaseViewControllerProtcol
	func mainNavigationController() -> UINavigationController? {
		return navigationController
	}
	
	func mainView() -> UIView? {
		return view
	}
	
	func showLoading() {
		MBProgressHUD.showAdded(to: navigationController?.view, animated: true)
	}
	
	func hideLoading() {
		MBProgressHUD.hideAllHUDs(for: navigationController?.view, animated: true)
	}
	
	func reloadData() {
		tableView.reloadData()
	}
}
