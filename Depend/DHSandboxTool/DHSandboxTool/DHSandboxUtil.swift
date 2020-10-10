//
//  DHSanboxUtil.swift
//  DHSanboxTool
//
//  Created by iblue on 2020/10/9.
//

import UIKit

class DHSandboxUtil: NSObject {
    
    //MARK: - Build Nodes
    /// 获取目录下的沙盒节点
    /// - Parameter targetPath: 目标路径
    /// - Returns: 节点
    class func getSandboxNode(targetPath: String) -> DHSanboxNodeModel {
        var node = DHSanboxNodeModel()
        node.path = targetPath
        generateSubNodes(node: node)
        return node
    }
    
    
    /// 获取子节点
    /// - Parameter node: 节点
    class func generateSubNodes(node: DHSanboxNodeModel) {
        let fileManager = FileManager.default
        var directory: ObjCBool = ObjCBool(false)
        let isExisted = fileManager.fileExists(atPath: node.path, isDirectory: &directory)
        if isExisted && !directory.boolValue {
            node.nodeType = .file
            node.name = (node.path as NSString).lastPathComponent
            return
        }
        
        node.nodeType = .directory
        
        //初始化子节点
        node.subNodes = [DHSanboxNodeModel]()
        
        //添加一个返回上一级的节点
        if node.parentNode != nil {
            var subNode = DHSanboxNodeModel()
            subNode.nodeType = .back
            subNode.name = "返回上一级"
            subNode.path = ""
            subNode.parentNode = node
            node.subNodes?.append(subNode)
        }

        //遍历添加子节点
        let paths = try? fileManager.contentsOfDirectory(atPath: node.path)
        paths?.forEach({ (path) in
            var directory: ObjCBool = ObjCBool(false)
            let fullPath = (node.path as NSString).appendingPathComponent(path)
            fileManager.fileExists(atPath: fullPath, isDirectory: &directory)
            
            var subNode = DHSanboxNodeModel()
            subNode.path = fullPath
            subNode.name = path
            subNode.parentNode = node
            
            if directory.boolValue == true {
                subNode.nodeType = .directory
            } else {
                subNode.nodeType = .file
            }
            
            //获取大小
            subNode.size = getLocalizedFileSize(path: subNode.path)
            node.subNodes?.append(subNode)
        })
    }
    
    //MARK: - File Size
    
    /// 获取指定目录/文件的大小
    /// - Parameter path: 路径
    /// - Returns: 计量单位B
    class func getFileSize(path: String) -> Int {
        var size: Int = 0 //B
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = ObjCBool(false)
        let isExist = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        if !isExist {
            return size
        }
        
        if isDirectory.boolValue {
            let paths = try? fileManager.contentsOfDirectory(atPath: path)
            paths?.forEach({ (contentObject) in
                let subPath = (path as NSString).appendingPathComponent(contentObject)
                size = size + getFileSize(path: subPath)
            })
        } else {
            if let attr = try? fileManager.attributesOfItem(atPath: path),
               let sizeValue = attr[FileAttributeKey.size] as? Int {
                size = size + sizeValue
            }
        }
        
        return size
    }
    
    /// 获取指定目录/文件的大小，自动适配B/KB/MB
    /// - Parameter path: 路径
    /// - Returns: xx B/KB/MB
    class func getLocalizedFileSize(path: String) -> String {
        let sizeValue: Double = Double(getFileSize(path: path))
        var sizeStr = ""
        
        if sizeValue > 1024 * 1024 {
            sizeStr = String(format: "%0.2f MB", sizeValue / 1024 / 1024)
        } else if sizeValue > 1024 {
            sizeStr = String(format: "%0.2f KB", sizeValue / 1024)
        } else {
            sizeStr = String(format: "%0.0f B", sizeValue)
        }
        
        return sizeStr
    }
    
    //MARK: - Share
    class func share(object: Any, fromVC: UIViewController) {
        let shareItems = [object]
        let activityVc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        fromVC.present(activityVc, animated: true, completion: nil)
    }
    
    //MARK: - Toast Alert
    class func showAlert(message: String, fromVC: UIViewController) {
        let alertVc = UIAlertController(title: "", message: message, preferredStyle: .alert)
        fromVC.present(alertVc, animated: true, completion: nil)
        
        let cancelAction = UIAlertAction(title: "确定", style: .destructive, handler: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alertVc.dismiss(animated: true, completion: nil)
        }
    }
}
