//
//  ViewController.swift
//  Clip
//
//  Created by jiangbin on 2021/9/23.
//  Copyright © 2021 iblue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        testAddClick()
    }

    func testAddClick() {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 30, y: 100, width: 120, height: 44)
        btn.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        btn.backgroundColor = UIColor.orange
        btn.setTitle("Hello Clip", for: .normal)
        view.addSubview(btn)
    }
    
    @objc func onClick() {
        
    }
}

