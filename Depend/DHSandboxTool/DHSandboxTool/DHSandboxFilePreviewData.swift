//
//  DHSandboxFileDetailViewController.swift
//  DHSandboxTool
//
//  Created by iblue on 2020/10/9.
//  沙盒文件查看器

import UIKit
import QuickLook

class DHSandboxFilePreviewData: NSObject,QLPreviewControllerDelegate,QLPreviewControllerDataSource {
    
    /// 文件路径
    var filePath: String = ""
    
    class func canpreview(filePath: String) -> Bool {
        let fileUrl = NSURL(fileURLWithPath: filePath)
        return QLPreviewController.canPreview(fileUrl)
    }

    //MARK: - QLPreviewControllerDataSource
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let fileUrl = NSURL(fileURLWithPath: filePath)
        print("🍎🍎🍎 \(Date()) \(NSStringFromClass(self.classForCoder))::\(fileUrl)")
        return fileUrl 
    }
}
