//
//  StockViewController.swift
//  MyTestProject
//
//  Created by iblue on 2020/10/16.
//  Copyright © 2020 iblue. All rights reserved.
//

import UIKit

class StockViewController: UIViewController {
    
    var model: StockRequest = StockRequest()
    
    var stockList: [String] = [String]()
    
    var enableShowText: Bool = false

    var text: String = ""
    
    var timer: DispatchSourceTimer?
    
    var timerInterval: TimeInterval = TimeInterval(5.1) * 1_000
    
    @IBOutlet weak var btnHide: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        loadStockList()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    
    func loadStockList() {
        if let filePath = Bundle.main.path(forResource: "Stocks", ofType:"plist") {
            let dicValues = FPFileHelper.readPropertyList(plistPath: filePath)
            stockList.removeAll()
            stockList.append(contentsOf: dicValues.keys.sorted())
        }
    }
    
    //MARK: - Update UI
    func updateUI() {
        let title = enableShowText ? "hide" : "show"
        btnHide.setTitle(title, for: .normal)
        textView.text = enableShowText ? text : ""
    }
    
    //MARK: - Action
    @IBAction func switchAction(_ sender: UIButton) {
        enableShowText = !enableShowText
        updateUI()
    }
    
    @IBAction func onRefreshAction(_ sender: Any) {
        request()
    }
    
    @IBAction func onClearAction(_ sender: Any) {
        text = ""
        textView.text = ""
    }
    
    //MARK: - Timer
    func startTimer() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.schedule(deadline: DispatchTime.now(), repeating: .milliseconds(Int(timerInterval)), leeway: .microseconds(100))
        timer?.setEventHandler {
            self.request()
        }
        
        timer?.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
    }
    
    //MARK: - Request
    func request() {
        model.request(stocks: stockList) { [unowned self] (stocks) in
            let reverse = stocks.reversed()
            reverse.forEach { (stockInfo) in
                text = stockInfo.description + "\n" + text
            }
            
            if enableShowText == false {
                return
            }
            
            text = "!=======更新\(Date().fp_string(FPDateFormat.Hour))=======!\n" + text
            textView.text = text
        }
    }
}
