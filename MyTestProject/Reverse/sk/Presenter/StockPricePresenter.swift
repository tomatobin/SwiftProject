//
//  StockPricePresenter.swift
//  MyTestProject
//
//  Created by iblue on 2021/1/25.
//  Copyright © 2021 iblue. All rights reserved.
//

import UIKit

protocol IStockPricePresenter: class {
    
    func startTimer()
    
    func stopTimer()
    
    func numberOfRowsInSection(section: Int) -> Int
    
    func updateCell(cell: UITableViewCell, indexPath: IndexPath)
}

class StockPricePresenter: NSObject,IStockPricePresenter {
    
    weak var priceView: IStockPriceView?
    
    var model: StockRequest = {
        let reqeustModel = StockRequest()
        reqeustModel.showColor = false
        reqeustModel.showLog = true
        return reqeustModel
    }()
    
    var stockCodeList: [String] = [String]()
    
    var stockInfoList: [StockInfo] = [StockInfo]()
    
    var timer: DispatchSourceTimer?
    
    var timerInterval: TimeInterval = TimeInterval(StockConfigManager.sharedInstance.time * 1_000)
    
    var logInfo: String? = ""
    
    required init(view: IStockPriceView) {
        super.init()
        priceView = view
        loadStockList()
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
        let monitorCode = StockConfigManager.sharedInstance.code
        let monitorMinPrice = StockConfigManager.sharedInstance.minPrice
        let monitorMaxPrice = StockConfigManager.sharedInstance.maxPrice
        
        var content = ""
        model.request(stocks: stockCodeList) { [weak self] (stocks) in
            stocks.forEach { (stockInfo) in
                
                if !monitorCode.contains("sh000001"), stockInfo.code.contains("sh000001") {
                    content = stockInfo.currentPrice + " " + stockInfo.localizedComparePricePercent
                }
                
                let price = Double(stockInfo.currentPrice) ?? 0
                if self?.isInTipTime() == true, monitorCode.count > 0, stockInfo.code.contains(monitorCode) {
                    if price < monitorMinPrice || price > monitorMaxPrice {
                        content = "\(stockInfo.time) \(stockInfo.currentPrice) \(content)"
                        VKNotificationService.sharedInstance.localNotificationRequest(title: "Attention...", body: content, logo: "")
                    }
                }
            }
            
            self?.stockInfoList.removeAll()
            self?.stockInfoList.append(contentsOf: stocks)
            self?.stockInfoList.sort(by: {return $0.comparePercent > $1.comparePercent})
            self?.priceView?.updateTableView()
        }
        
        //超过时间不进行定时更新，但至少保证更新一次
        if isInTipTime() == false {
            stopTimer()
        }
    }
    
    func isInTipTime() -> Bool {
        let currentTime = Date().timeIntervalSince1970
        let beginTime = Date().fp_startOfDay().timeIntervalSince1970
        let timeInterval = currentTime - beginTime
        
        if timeInterval > 9.5 * 3600, timeInterval < 15 * 3600 + 30 {
            return true
        }
        
        return false
    }
    
    //MARK: - Table Protocol
    func numberOfRowsInSection(section: Int) -> Int {
        return stockInfoList.count
    }
    
    func updateCell(cell: UITableViewCell, indexPath: IndexPath) {
        guard indexPath.row < stockCodeList.count else {
            return
        }
        
        guard let priceCell = cell as? StockPirceTableViewCell else {
            return
        }
        
        let stock = stockInfoList[indexPath.row]
        priceCell.updateCellByStock(stock: stock)
    }
    
    //MARK: - Private
    func loadStockList() {
        if let filePath = Bundle.main.path(forResource: "Stocks", ofType:"plist") {
            let dicValues = FPFileHelper.readPropertyList(plistPath: filePath)
            stockCodeList.append(contentsOf: dicValues.keys.sorted())
        }
    }
}
