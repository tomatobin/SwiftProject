//
//  DHSanboxModel.swift
//  Pods
//
//  Created by iblue on 2020/10/9.
//

import UIKit

/// 节点类型
/// directory -- 目录
/// file -- 文件
/// back -- 返回
enum DHSandboxNodeType: Int {
    case directory = 0
    case file = 1
    case back = 2
}

class DHSanboxNodeModel: NSObject {
    
    var name: String = ""
    
    var path: String = ""
    
    var size: String = ""
    
    var nodeType: DHSandboxNodeType = .directory
    
    /// 子节点列表（下一层级）
    var subNodes: [DHSanboxNodeModel]?
    
    /// 父节点
    weak var parentNode: DHSanboxNodeModel?
}
