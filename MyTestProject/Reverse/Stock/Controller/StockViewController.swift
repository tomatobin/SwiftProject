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
    
    var timerInterval: TimeInterval = TimeInterval(StockConfigManager.sharedInstance.time * 1_000)
    
    var lastNotifyTime: TimeInterval = Date().timeIntervalSince1970
    
    @IBOutlet weak var btnHide: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initNaviRightItem()
        updateUI()
        loadStockList()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timerInterval = TimeInterval(StockConfigManager.sharedInstance.time * 1_000)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    
    //MARK: - Navigation
    func initNaviRightItem() {
        let configBtn = UIButton(type: .system)
        configBtn.setTitle("配置", for: .normal)
        configBtn.addTarget(self, action: #selector(onNaviRightAction), for: .touchUpInside)
        
        let configItem = UIBarButtonItem(customView: configBtn)
        navigationItem.rightBarButtonItems = [configItem]
    }
    
    @objc func onNaviRightAction() {
        performSegue(withIdentifier: "pushStockConfig", sender: nil)
    }
    
    //MARK: - Init Data
    func loadStockList() {
        if let filePath = Bundle.main.path(forResource: "Stocks", ofType:"plist") {
            let dicValues = FPFileHelper.readPropertyList(plistPath: filePath)
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
    
    @IBAction func onColorAction(_ sender: Any) {
        model.showColor = !model.showColor
    }
    
    @IBAction func onLogAction(_ sender: Any) {
        model.showLog = !model.showLog
    }
    
    //MARK: - Timer
    func startTimer() {
        stopTimer()
        
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
        model.request(stocks: stockList) { [weak self] (stocks) in
            let reverse = stocks.reversed()
            let monitorCode = StockConfigManager.sharedInstance.code
            let monitorMinPrice = StockConfigManager.sharedInstance.minPrice
            let monitorMaxPrice = StockConfigManager.sharedInstance.maxPrice
            
            reverse.forEach { (stockInfo) in
                self?.text = stockInfo.description + "\n" + (self?.text ?? "")
                let currentTime = Date().timeIntervalSince1970
                
                let price = Double(stockInfo.currentPrice) ?? 0
                if self?.isInTipTime() == true, monitorCode.count > 0, stockInfo.code.contains(monitorCode)  { //
                    if price < monitorMinPrice || price > monitorMaxPrice {
                        let content = "\(stockInfo.time) \(stockInfo.currentPrice)"
                        VKNotificationService.sharedInstance.localNotificationRequest(title: "Attention...", body: content, logo: "")
                        self?.lastNotifyTime = currentTime
                    }
                }
            }
            
            if self?.enableShowText == false {
                return
            }
            
            self?.text = "!=======更新\(Date().fp_string(FPDateFormat.Hour))=======!\n" + (self?.text ?? "")
            self?.textView.text = self?.text
            
            if self?.isInTipTime() == false {
                self?.stopTimer()
            }
        }
    }
    
    func isInTipTime() -> Bool {
        let currentTime = Date().timeIntervalSince1970
        let beginTime = Date().fp_startOfDay().timeIntervalSince1970
        let timeInterval = currentTime - beginTime
        
        if timeInterval > 9.5 * 3600, timeInterval < 15 * 3600 {
            return true
        }

        return false
    }
}

