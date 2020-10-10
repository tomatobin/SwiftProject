//
//  Configration.swift
//  FPSwift
//
//  Created by iblue on 16/7/17.
//  Copyright © 2016年 iblue. All rights reserved.
//  配置文件读写：运行时或文件，跟用户无关的数据 

import UIKit

let CONFIG_USERNAME = "username"    //用户名
let CONFIG_PASSWORD = "password"    //密码
let CONFIG_CLIENTID = "clientId" //个推id
let CONFIG_RUNTIME_SEARCH_ANIMATION = "searchAnimation" //首页按钮动画
let CONFIG_SHOWGUIDE_PAGE = "showGuidePage"

class Configration: NSObject {
    //单例实现
    static let sharedInstance: Configration = Configration()
    
    fileprivate var runtimeRef: NSMutableDictionary!
    fileprivate var fileRef: NSMutableDictionary!
    
    fileprivate override init() {
        super.init()
        ColorLog.cyan("Configraion init...")
        self.runtimeRef = NSMutableDictionary()
        self.loadFile()
    }
    
    //MARK: Public
    class func configFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return ((documentPath)! + "/config.plist")
    }
    
    class func readConfig(forKey key: String) -> AnyObject? {
        if key.count == 0 {
            return nil
        }
        
        var object = sharedInstance.runtimeRef.object(forKey: key)
        if object != nil {
            return object as AnyObject?
        }
        
        object = sharedInstance.fileRef.object(forKey: key)
        if object != nil {
            return object as AnyObject?
        }
        
        return nil
    }
    
    class func removeConfig(forKey key:String) {
        sharedInstance.runtimeRef.removeObject(forKey: key)
        sharedInstance.fileRef.removeObject(forKey: key)
    }
    
    class func writeFileConfig(_ object: AnyObject?, key: String) {
        if object == nil {
            sharedInstance.fileRef.removeObject(forKey: key)
        }else{
            sharedInstance.fileRef.setObject(object!, forKey: key as NSCopying)
        }
        
        self.saveFile()
    }
    
    class func wirteRuntimeConfig(_ object: AnyObject?, key: String) {
        if object == nil {
            sharedInstance.runtimeRef.removeObject(forKey: key)
        }else{
            sharedInstance.runtimeRef.setObject(object!, forKey: key as NSCopying)
        }
    }
    
    func loadFile() {
        let filePath = Configration.configFilePath()
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            self.fileRef = NSMutableDictionary(contentsOfFile: filePath)
        }
        else{
            self.fileRef = NSMutableDictionary()
        }
    }
    
    class func saveFile() {
        let filePath = Configration.configFilePath()
        sharedInstance.fileRef.write(toFile: filePath, atomically: true)
    }
}

