//
//  StockConfigViewController.swift
//  MyTestProject
//
//  Created by iblue on 2020/12/4.
//  Copyright © 2020 iblue. All rights reserved.
//

import UIKit

class StockConfigViewController: UIViewController {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var codeTxf: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var minTxf: UITextField!
    @IBOutlet weak var maxTxf: UITextField!
    @IBOutlet weak var timeTxf: UITextField!
    
    static func storyboardInstance() -> StockConfigViewController {
        let storyboard = UIStoryboard(name: "Reverse", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StockConfigViewController")
        return controller as! StockConfigViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadConfig()
        addTapGesture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveConfig()
    }
    
    //MARK: - Tap
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        view.endEditing(true)
    }
    
    //MARK: - User Defalut Operation
    func loadConfig() {
        codeTxf.text = StockConfigManager.sharedInstance.code
        minTxf.text = String(format: "%0.2f", StockConfigManager.sharedInstance.minPrice)
        maxTxf.text = String(format: "%0.2f", StockConfigManager.sharedInstance.maxPrice)
        timeTxf.text = String(format: "%0.2f", StockConfigManager.sharedInstance.time)
    }
    
    func saveConfig() {
        if let showCode = codeTxf.text {
            StockConfigManager.sharedInstance.code = showCode
        }
        
        if let showMinPrice = Double(minTxf.text ?? "") {
            StockConfigManager.sharedInstance.minPrice = showMinPrice
        }
        
        if let showMaxPrice = Double(maxTxf.text ?? "") {
            StockConfigManager.sharedInstance.maxPrice = showMaxPrice
        }
        
        if let showTime = Double(timeTxf.text ?? "8.97") {
            StockConfigManager.sharedInstance.time = showTime
        }
        
        StockConfigManager.sharedInstance.saveConfig()
    }
}
