//
//  CityVCProtocol.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/23.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

/// ViewController需要实现的基础协议
protocol BaseVCProtocol: class {
	
	/// 返回导航控制器
	func mainNavigationController() -> UINavigationController?
	
	/// 返回Controller的View
	func mainView() -> UIView?
}

/// 城市列表VC协议
protocol CityVCProtocol: BaseVCProtocol {
	
	/// 更新列表
	func reloadData()
	
	/// 显示加载
	func showLoading()
	
	/// 隐藏加载
	func hideLoading()
}

/// 解释器实现的协议
protocol CityPresenterProtocol: class {
	/// 返回列表section数量
	func numberOfSections() -> Int
	
	/// 返回section对应的行数
	func numberOfRows(section: Int) -> Int
	
	/// 设置cell
	func configure(cell: UITableViewCell, indexPath: IndexPath)
	
	/// 选中cell
	func didSelect(table: UITableView, indexPath: IndexPath)
	
	/// 刷新数据
	func refreshCityData()
}

//MARK:CityPresenter

class CityPresenter: CityPresenterProtocol {

	/// Controller
	weak var cityView: CityVCProtocol?
	
	/// Model
	private var cityArray: [CityInfo] = [CityInfo]()
	
	init() {
		refreshCityData()
	}

	//MARK: CityPresenterProtocol
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
