//
//  WidgetsModule.swift
//  MyTestProject
//
//  Created by iblue on 2017/7/7.
//  Copyright © 2017年 iblue. All rights reserved.
//

import UIKit
import BeeHive
import MGJRouter

class WidgetsModule: NSObject,BHModuleProtocol {

    //Swift 禁止调用该方法
//    override class func load() {
//        
//    }
    
    func modInit(_ context: BHContext!) {
        //初始化
    }
    
     func modSetUp(_ context: BHContext!) {
       // BeeHive.shareInstance().registerService(WidgetsHudServiceProtocol, service: WidgetsController.classForCoder())
        BeeHive.shareInstance().registerService(WidgetsHudServiceProtocol.self, service: MBHUDController.classForCoder())
        
//        //不带返回值的
//        MGJRouter.registerURLPattern("my://widgets/hud") { (_: [AnyHashable : Any]?) -> (Void) in
//            
//        }
        
//        //带返回值的
//        MGJRouter.registerURLPattern("my://widgets/hud") { ( parameters : [AnyHashable : Any]?) -> (UIViewController?) in
//            let hudVc = MBHUDController.storyboardInstance()
//            let userInfo = parameters?["MGJRouterParameterUserInfo"] as? [AnyHashable : Any]
//            if let dissmissTime = userInfo?["dissmissTime"], dissmissTime is Double,
//                let naviVc = userInfo?["NavigationVc"], naviVc is UINavigationController {
//                hudVc?.dismissTime = dissmissTime as! Double
//                (naviVc as! UINavigationController).pushViewController(hudVc!, animated: true)
//            }
//            
//            return hudVc
//        }
        
        //使用url参数
        MGJRouter.registerURLPattern("my://widgets/hud?dismissTime=&title=") { ( parameters : [AnyHashable : Any]?) -> (UIViewController?) in
            let hudVc = MBHUDController.storyboardInstance()
            let userInfo = parameters?["MGJRouterParameterUserInfo"] as? [AnyHashable : Any]
            if let dissmissTime = parameters?["dismissTime"],
                let naviVc = userInfo?["NavigationVc"], naviVc is UINavigationController {
                hudVc?.dismissTime = Double(dissmissTime as! String)!
                hudVc?.title = parameters?["title"] as? String
                (naviVc as! UINavigationController).pushViewController(hudVc!, animated: true)
            }
            
            return hudVc
        }
    }
}
