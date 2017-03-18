//
//  UITableView+Extension.swift
//  FPSwift
//
//  Created by iblue on 16/11/6.
//  Copyright © 2016年 iblue. All rights reserved.
//

import Foundation

extension UITableView {
    
    /// 使用FootView隐藏多余的行
    ///
    /// - Parameter color: 默认颜色
    func fp_setExtraRowsHidden(backgroudColor color: UIColor = UIColor.fp_mainBgColor()) {
        let view = UIView()
        view.backgroundColor = color
        self.tableFooterView = view
    }
}
