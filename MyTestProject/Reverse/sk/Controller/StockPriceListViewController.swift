//
//  StockPriceListViewController.swift
//  MyTestProject
//
//  Created by iblue on 2021/1/25.
//  Copyright © 2021 iblue. All rights reserved.
//

import UIKit

class StockPriceListViewController: UIViewController,IStockPriceView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showButton: UIButton!
    
    var presenter: IStockPricePresenter!
    var showStockInfo: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter = StockPricePresenter(view: self)
        setupTableView()
        initNaviRightItem()
        updateShowUI(show: showStockInfo)
        
        DHBackgroundRunner.shared.openRunner = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.stopTimer()
    }
    
    deinit {
        DHBackgroundRunner.shared.openRunner = false
        print("🍎🍎🍎 \(NSStringFromClass(self.classForCoder)):: deinit :)...")
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Navigation
    func initNaviRightItem() {
        let configBtn = UIButton(type: .system)
        configBtn.setTitle("Config", for: .normal)
        configBtn.addTarget(self, action: #selector(onNaviRightAction), for: .touchUpInside)
        
        let configItem = UIBarButtonItem(customView: configBtn)
        navigationItem.rightBarButtonItems = [configItem]
    }
    
    @objc func onNaviRightAction() {
        let configVc = StockConfigViewController.storyboardInstance()
        configVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(configVc, animated: true)
    }
    
    //MARK: - IStockPriceView
    func updateTableView() {
        tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockPirceTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        presenter.updateCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - Action
    @IBAction func onShowAction(_ sender: UIButton) {
        showStockInfo = !showStockInfo
        updateShowUI(show: showStockInfo)
    }
    
    func updateShowUI(show: Bool) {
        showStockInfo = show
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = show ? 1 : 0
        }
        
        let title = show ? "Hide" : "Show"
        showButton.setTitle(title, for: .normal)
    }
}

class StockPirceTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var diffPriceLabel: UILabel!
    @IBOutlet weak var detailPrice: UILabel!
    
    var showWithColor: Bool = true
    
    static func identifier() -> String {
        return "StockPirceTableViewCell"
    }
    
    func setDefaultConfig() {
#if TARGET_IPHONE_SIMULATOR
        showWithColor = false
#endif
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDefaultConfig()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDefaultConfig()
    }
    
    func updateCellByStock(stock: StockInfo) {
        nameLabel.text = stock.name
        codeLabel.text = stock.code
        currentPriceLabel.text = stock.currentPrice
        diffPriceLabel.text = stock.localizedComparePricePercent + " " + stock.localizedComparePrice
        detailPrice.text = "开:\(stock.openPrice) 昨:\(stock.yesterdayClosePrice) \n低:\(stock.minPrice) 高:\(stock.maxPrice) 均:\(stock.averagePrice)"
        
        if showWithColor {
            let stateImagename = stock.comparePrice < 0 ? "stock_drop" : "stock_rise"
            stateImageView?.image = UIImage(named: stateImagename)
            
            let color = stock.comparePrice < 0 ? UIColor.systemGreen : UIColor.systemRed
            currentPriceLabel.textColor = color
            diffPriceLabel.textColor = color
        } else {
            stateImageView.image = nil
            currentPriceLabel.textColor = .black
            diffPriceLabel.textColor = .black
        }
    }
}
