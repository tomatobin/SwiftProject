//
//  MPaaSScanViewController.swift
//  MyTestProject
//
//  Created by jiangbin on 2021/9/15.
//  Copyright © 2021 iblue. All rights reserved.
//

import UIKit


class MPaaSScanViewController: UIViewController { //,TBScanViewControllerDelegate {
    
//    lazy var scanVc: TBScanViewController = {
//        let vc = TBScanViewController(animationRect: CGRect(x: 30, y: 30, width: 300, height: 300), delegate: self)!
//        return vc
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        configScanVc()
//    }
//
//    func configScanVc() {
//        addChild(scanVc)
//        scanVc.view.frame = view.frame
//        scanVc.scanType = ScanType_QRCode
//        scanVc.bAutoZoomEnable = true
//        scanVc.cameraWidthPercent = 1
//        view.addSubview(scanVc.view)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        scanVc.resumeScan()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        scanVc.pauseScan()
//    }
//
//    //MARK: - TBScanViewControllerDelegate
//    func didFind(_ resultArray: [TBScanResult]!) {
//        guard let result = resultArray.first else {
//            scanVc.resumeScan()
//            return
//        }
//
//        DispatchQueue.main.async {
//            var tip = "ScanResult: \(result.data ?? "")"
//            if let hiddenData = result.hiddenData {
//                tip = tip + " HiddenData: \(hiddenData)"
//            }
//
//            let tipVc = UIAlertController(title: "", message: tip, preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default) { _ in
//                tipVc.dismiss(animated: true, completion: nil)
//                self.scanVc.resumeScan()
//            }
//            tipVc.addAction(action)
//
//            self.present(tipVc, animated: true, completion: nil)
//        }
//    }
}


