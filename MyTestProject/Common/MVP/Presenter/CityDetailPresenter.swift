//
//  CityDetailPresenter.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/24.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

protocol CityDetailPresenterProtocol: class {
	
	func updateTitle(label: UILabel)
}

/// 城市列表VC协议
protocol CityDetailVCProtocol: BaseViewControllerProtcol {
	
}

class CityDetailPresenter: CityDetailPresenterProtocol {
	
	weak var detailView: CityDetailViewController?
	
	var city: CityInfo?
	
	func updateTitle(label: UILabel) {
		label.text = city?.name
	}
}
