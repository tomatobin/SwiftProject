//
//  WidgetsController.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/19.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

class WidgetsController: FPBaseController,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: FPTableDataSource!
    var data: Dictionary<String,String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Widgets"
        data = ["MBProgressHUD" : "PushToMBProgressHUD",
                "CustomWidgets": "PushToCustomWidgets",
                "BlurEffect": "PresentBlur",
                "Fliter": "PushToFliter",
                "TableHeader": "PushToTableHeader",
                "Spring": "PushToSpring",
				"LightButton": "PushToLightButton",
				"ModelSelect": "PushToTypesSelect",
				"ApGuide": "PushToApGuide",
				"TestVC": "TestVC",
				"NVRMiddlePage": "PushToNvrMiddlePage"]
        self.configureTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView(){
        let identifier = FPTableViewCell.cellIdentifier()
        
        var dataArray = [FPTableViewCellData]()
        for key in Array(data.keys) {
            let celldata = FPTableViewCellData(title: key, imageName: "star_yellow", detail: nil, type: .normal)
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

extension WidgetsController{
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FPTableViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let allValues = Array(data.values) as Array<String>
        if indexPath.row < allValues.count {
            let pushSegue = allValues[indexPath.row]
			
			if pushSegue == "TestVC" {
				self.testVC()
			} else {
				self.performSegue(withIdentifier: pushSegue, sender: nil)
			}
        }
    }
	
	func testVC() {
		let vc = DHInputSNViewController.storyboardInstance()
		self.navigationController?.pushViewController(vc, animated: true)
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? FPBlurController {
            controller.modalPresentationStyle = .overFullScreen
            controller.modalTransitionStyle = .crossDissolve
		} else if let controller = segue.destination as? DHApGuideViewController {
			var guides = [DHApGuideInfo]()
			for index in 0...3 {
				var guide = DHApGuideInfo()
				guide.tipText = "这是第\(index)步\n请描述内容"
				
				if index == 3 {
					guide.isCheckHidden = false
				}
				
				guides.append(guide)
			}
			
			controller.setup(guides: guides)
		}
    }
}
