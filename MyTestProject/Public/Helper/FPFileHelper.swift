//
//  FPFileHelper.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/5.
//  Copyright © 2016年 iblue. All rights reserved.
//

import Foundation

class FPFileHelper: NSObject {
    static func isFileExsited(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// 读取plist文件内容
    /// - Parameter plistPath: plist文件地址
    /// - Returns: Dictionary
    class func readPropertyList(plistPath: String) -> [String: AnyObject] {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: [String: AnyObject] = [:]
        if let plistXML = FileManager.default.contents(atPath: plistPath) {
            do {
                //convert the data to a dictionary and handle errors.
                plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String: AnyObject]
                
            } catch {
                print("Error reading plist: \(error), format: \(propertyListFormat)")
            }
        }

        return plistData
    }
}
