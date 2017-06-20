//
//  TableHeaderController.swift
//  MyTestProject
//
//  Created by jiangbin on 2017/6/19.
//  Copyright © 2017年 iblue. All rights reserved.
//

import UIKit

class TableHeaderController: FPBaseController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var imageView: UIImageView!
    
    var topHeight: CGFloat = CGFloat(300)
    
    deinit {
        fp_testDeinit(self)
        
        //由于在内部的弱引用会被重置为nil，暂时在上层处理
        self.tableView.removeObserver(self.tableView.fp_header, forKeyPath: FPRefreshKeyPathContentOffset, context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView = UIImageView(frame: CGRect(x: 0, y: -topHeight, width: self.view.bounds.width, height: topHeight))
        imageView.image = UIImage(named: "table_header")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true //裁剪超出的部分，scaleAspectFill的影响
        self.tableView.addSubview(imageView)
        
        self.tableView.contentInset = UIEdgeInsetsMake(topHeight , 0, 0, 0)
        self.tableView.register(UITableViewCell.classForCoder(),forCellReuseIdentifier: "HeaderCell")
        
        let header = FPRefreshHeader()
        weak var weakself = self
        header.refreshingBlock = {
            
            //注意循环引用
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
                weakself?.refreshEnd()
            })
        }
        
        self.tableView.fp_header = header
        
        self.tableView.fp_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshEnd() {
        self.tableView.fp_header.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //MARK: ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset < -topHeight {
            self.imageView.frame = CGRect(x: 0, y: yOffset, width: self.imageView.frame.width, height: -yOffset)
        }
    }
}
