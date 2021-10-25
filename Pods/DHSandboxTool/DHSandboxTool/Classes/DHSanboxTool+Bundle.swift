//
//  DHScanne+Bundle.swift
//  DHScanner
//
//  Created by jiangbin on 2018/3/13.
//  Copyright © 2018年 jiangbin. All rights reserved.
//

import UIKit

extension Bundle {
    
    static var sandboxBundle: Bundle? = nil
    
    class func dh_sandboxBundle() -> Bundle? {
        if self.sandboxBundle == nil, let path = Bundle(for: DHSanboxNodeModel.classForCoder()).path(forResource: "DHSandboxTool", ofType: "bundle") {
            self.sandboxBundle = Bundle(path: path)
        }
        
        return self.sandboxBundle
    }
    
    class func dh_sandboxBundleImage(named name: String) -> UIImage? {
        let image = UIImage(named: name, in: self.dh_sandboxBundle(), compatibleWith: nil)
        return image
    }
}
