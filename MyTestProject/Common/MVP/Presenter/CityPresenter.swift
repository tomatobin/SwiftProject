//
//  CityVCProtocol.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/23.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

/// 基础的VC协议，
protocol BaseViewControllerProtcol: class {
	func mainNavigationController() -> UINavigationController?
	func mainView() -> UIView?
}

/// 城市列表VC协议
protocol CityVCProtocol: BaseViewControllerProtcol {
	func reloadData()
	func showLoading()
	func hideLoading()
}

/// 解释器实现的协议
protocol CityPresenterProtocol: class {
	func numberOfSections() -> Int
	func numberOfRows(section: Int) -> Int
	func configure(cell: UITableViewCell, indexPath: IndexPath)
	func didSelect(table: UITableView, indexPath: IndexPath)
	func refreshCityData()
}

//MARK:CityPresenter

class CityPresenter: CityPresenterProtocol {

	/// Controller
	weak var cityView: CityVCProtocol?
	
	private var cityArray: [CityInfo] = [CityInfo]()
	
	init() {
		refreshCityData()
	}

	func numberOfSections() -> Int {
		return 1
	}
	
	func numberOfRows(section: Int) -> Int {
		return cityArray.count
	}
	
	func configure(cell: UITableViewCell, indexPath: IndexPath) {
		let city = cityArray[indexPath.row]
		cell.textLabel?.text = city.name
		cell.detailTextLabel?.text = city.detail
		cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
		cell.detailTextLabel?.textColor = UIColor.lc_colorWithHexString("2c2c2c")
	}
	
	func didSelect(table: UITableView, indexPath: IndexPath) {
		//跳转城市详情页
		let city = cityArray[indexPath.row]
		let detailVc = CityDetailViewController.storyboardInstance()
		let presenter = CityDetailPresenter()
		detailVc.presenter = presenter
		presenter.detailView = detailVc
		presenter.city = city
		cityView?.mainNavigationController()?.pushViewController(detailVc, animated: true)
	}
	
	func refreshCityData() {
		
		cityView?.showLoading()
		
		DispatchQueue.global().async {
			//获取数据.
			self.cityArray.removeAll()
			for index in 0..<arc4random()%20 {
				let city = CityInfo()
				city.name = "City index - \(index)"
				city.detail = "This is a simple test cell...\(arc4random()%100)"
				self.cityArray.append(city)
			}
			
			sleep(3)
			
			DispatchQueue.main.async {
				self.cityView?.reloadData()
				self.cityView?.hideLoading()
			}
		}
	}
}
