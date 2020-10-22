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
    
//    var stockList: [String] = ["sz002236", "sh000001", "sh600827"]
    
    var stockList: [String] = ["sz002236", "sh000001"]
    
    var enableShowText: Bool = true

    var text: String = ""
    
    var timer: DispatchSourceTimer?
    
    var timerInterval: TimeInterval = TimeInterval(5) * 1_000
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Action
    @IBAction func switchAction(_ sender: UIButton) {
        enableShowText = !enableShowText
        let title = enableShowText ? "hide" : "show"
        sender.setTitle(title, for: .normal)
        textView.text = enableShowText ? text : ""
    }
    
    @IBAction func onRefreshAction(_ sender: Any) {
        request()
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
        text = textView.text ?? ""
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
