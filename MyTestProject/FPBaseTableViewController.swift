//
//  FPBaseTableViewController.swift
//  MyTestProject
//
//  Created by iblue on 2018/7/23.
//  Copyright © 2018年 iblue. All rights reserved.
//

import UIKit

class FPBaseTableViewController: UITableViewController {
	
	fileprivate var rotateLocked = Bool(false) //初始化不锁屏
	
	// 模拟导航栏底部的分隔线
	fileprivate var indicatorLine: UIView!
	var leftNaviButton: UIButton?
	
	/// 导航栏右侧按钮
	var rightNaviButtons = Array<UIButton>()
	
	deinit{
		ColorLog.purple("💔💔 \(NSStringFromClass(self.classForCoder)) deinit 💔💔" )
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.setNeedaLayoutNavigationBar()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.white
		
		//Assure view below navigation bar
		self.automaticallyAdjustsScrollViewInsets = false
		self.edgesForExtendedLayout = .all
		self.navigationController?.navigationBar.isTranslucent = false
		self.tabBarController?.tabBar.isTranslucent = false
		
		self.configNaviLeftButton()
		self.configNaviRightButtons()
		
		//Add Indicator Line
		self.indicatorLine = UIView()
		self.indicatorLine.isHidden = true
		self.indicatorLine.backgroundColor = UIColor.fp_colorWithHexString("A7A7AA")
		self.indicatorLine.frame = CGRect(x: 0, y: FP_NAVI_HEIGHT, width: FP_SCREEN_WIDTH, height: 0.5)
		self.view.addSubview(self.indicatorLine)
        self.view.bringSubviewToFront(self.indicatorLine)
	}
	
	fileprivate func configNaviLeftButton() {
		if let imageName = self.initNaviLeftItemFromImage() {
			let button = UIButton(type: .custom)
			button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
			//button.backgroundColor = UIColor.greenColor()
			button.contentHorizontalAlignment = .left
			button.addTarget(self, action: #selector(onBackAction), for: .touchUpInside)
            button.setImage(UIImage(named: imageName), for: UIControl.State())
			
			let barItem = UIBarButtonItem(customView: button)
			self.navigationItem.setLeftBarButton(barItem, animated: true)
			self.leftNaviButton = button
		}
	}
	
	fileprivate func configNaviRightButtons() {
		if let button = self.initNaviRightItemFromButton() {
			self.rightNaviButtons = [button]
			let barItem = UIBarButtonItem(customView: button)
			self.navigationItem.setRightBarButton(barItem, animated: true)
		}
		else if let imageArray = self.initNaviRightItemsFromImage() {
			var itemsArray = Array<UIBarButtonItem>()
			var indexTag = Int(0)
			for imageName in imageArray {
				let button = UIButton(type: .custom)
				button.frame = CGRect(x: 20, y: 0, width: 40, height: 40)
				button.tag = indexTag
				indexTag += 1
				button.addTarget(self, action: #selector(onNaviRightAction), for: .touchUpInside)
                button.setImage(UIImage(named: imageName), for: UIControl.State())
				button.sizeToFit()
				
				let barItem = UIBarButtonItem(customView: button)
				itemsArray.append(barItem)
				self.rightNaviButtons.append(button)
			}
			
			self.navigationItem.setRightBarButtonItems(itemsArray, animated: true)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: Navigaton bar
	/**
	通过图片定义导航栏左边返回按钮的按钮
	:returns: 图片名称
	*/
	func initNaviLeftItemFromImage() -> String? {
		return nil
	}
	
	/**
	通过图片定义导航栏右侧按按钮：【图片名称数组】
	
	- returns: 【图片名称数组】
	*/
	func initNaviRightItemsFromImage() -> Array<String>? {
		return nil
	}
	
	func initNaviRightItemFromButton() -> UIButton? {
		return nil
	}
	
	@objc func onBackAction() {
		_ = self.navigationController?.popViewController(animated: true)
	}
	
	@objc func onNaviRightAction(_ button: UIButton) {
		
	}
	
	/**
	改变导航栏底部分隔线状态
	
	- parameter show: true显示，false不显示
	*/
	func showIndicatorLine(showLine show: Bool) -> Void {
		self.indicatorLine.isHidden = !show
		if show {
            self.view.bringSubviewToFront(self.indicatorLine)
		}
	}
	
	/**
	强制更新导航栏，兼容iOS10
	*/
	func setNeedaLayoutNavigationBar() {
		if let leftView = self.navigationItem.leftBarButtonItem?.customView {
            self.navigationController?.navigationBar.bringSubviewToFront(leftView)
		}
		
		if let rightView = self.navigationItem.rightBarButtonItem?.customView {
            self.navigationController?.navigationBar.bringSubviewToFront(rightView)
		}
		
		if let titleView = self.navigationItem.titleView {
            self.navigationController?.navigationBar.bringSubviewToFront(titleView)
		}
	}
	
	override var preferredStatusBarStyle : UIStatusBarStyle {
		return .default
	}
	
	//MARK: Public Methods
	func lockRotate(){
		self.rotateLocked = true
	}
	
	func unlockRotate(){
		self.rotateLocked = false
	}
	
	//MARK: Rotate
	override var shouldAutorotate : Bool {
		return self.rotateLocked
	}
	
	override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
		return .portrait
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
