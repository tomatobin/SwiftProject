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
	func showLoading()
	func hideLoading()
}

protocol CityPresenter: class {
	func numberOfRows() -> Int
	func configureCell(cell: UITableViewCell)
}
