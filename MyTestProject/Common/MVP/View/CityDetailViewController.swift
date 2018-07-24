//
//  CityDetailViewController.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/24.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class CityDetailViewController: FPBaseController,BaseVCProtocol {

	var presenter: CityDetailPresenterProtocol?
	
	public static func storyboardInstance() -> CityDetailViewController {
		let storyboard = UIStoryboard(name: "MVP", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "CityDetailViewController")
		return controller as! CityDetailViewController
	}
	
	@IBOutlet weak var titleLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		presenter?.updateTitle(label: titleLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	//MARK: BaseViewControllerProtcol
	func mainNavigationController() -> UINavigationController? {
		return navigationController
	}
	
	func mainView() -> UIView? {
		return view
	}
}
