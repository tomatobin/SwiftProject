//
//  DHSelectModelViewController.swift
//  LCIphoneAdhocIP
//
//  Created by iblue on 2018/6/4.
//  Copyright © 2018年 dahua. All rights reserved.
//	设备类型选择界面

import UIKit


class DHSelectModelCollectionCell: UICollectionViewCell {
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	
}

class DHSelectModelHeaderView: UICollectionReusableView {
	
	@IBOutlet weak var titleLabel: UILabel!
	
}

class DHSelectModelViewController: FPBaseController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

	@IBOutlet weak var collectionView: UICollectionView!
	
	/// 每行显示的个数，数据源不足的填空的cell
	private var horizontalItemNumber = Int(4)
	
	/// 分隔线尺寸
	private var separatorSize = CGSize(width: 0.5, height: 0.5)
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.title = "设备选择"
		self.collectionView.backgroundColor = UIColor.fp_separatorColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	public static func storyboardInstance() -> DHSelectModelViewController {
		let storyboard = UIStoryboard(name: "AddDevice", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "DHSelectModelViewController")
		return controller as! DHSelectModelViewController
	}
	
	//MARK: UICollectionViewDataSource
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 3
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return horizontalItemNumber * 3
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DHSelectModelCollectionCell", for: indexPath) as! DHSelectModelCollectionCell
		cell.backgroundColor = UIColor.white
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DHSelectModelHeaderView", for: indexPath) as! DHSelectModelHeaderView
		
		return headView
	}
	
	//MARK: UICollectionViewDelegate
	
	//MARK: UICollectionViewDelegateFlowLayout
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.bounds.width - CGFloat(horizontalItemNumber - 1) * separatorSize.width) / 4
		return CGSize(width: width, height: 112)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.bounds.width, height: 35)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return separatorSize.height
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}

