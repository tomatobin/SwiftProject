//
//  FPFileHelper.swift
//  MyTestProject
//
//  Created by jiangbin on 16/7/5.
//  Copyright © 2016年 iblue. All rights reserved.
//

import Foundation

class FPFileHelper: NSObject {
    static func isFileExsited(path: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
}
