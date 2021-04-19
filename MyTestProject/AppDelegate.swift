//
//  AppDelegate.swift
//  MyTestProject
//
//  Created by jiangbin on 16/6/30.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit
import BeeHive
import LCLogManager
import CallKit
import CocoaSecurity

#if DEBUG
import DoraemonKit
#endif

@UIApplicationMain
class AppDelegate: BHAppDelegate {

    //var window: UIWindow?

    //后台任务
    var backgroundTask: UIBackgroundTaskIdentifier?
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.registerBackgroundPlay()
        self.registerNotification()
        self.initLog()
        self.initWeexSDK()
        self.initBeeHive(application: application, launchOptions: launchOptions)
        self.initDoraemonKit()
        self.setupVoIP()
        super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        let sha256 = CocoaSecurity.sha256("1imou-lechangeBG202102220001")
//        let decoder = CocoaSecurityDecoder()
//
//        let contentData = "8d22415838638cbe579b1017c6f1738bc453b569ef38a23ddc08d56d357904a9".fp_hexData()
//        let contentStr = String(data: contentData, encoding: String.Encoding.ascii)
//        print("Contentstr:\(contentStr)")
//
//        let ivData = decoder.hex("00000000000000000000000000000000")
//
//        let aesRest = CocoaSecurity.aesEncrypt("q12345678", key: sha256!.data, iv: ivData)
////        "q12345678".jm_encryptUseDes(key: "8d22415838638cbe579b1017c6f1738bc453b569ef38a23ddc08d56d357904a9", iv: nil)
////
////        let result = CocoaSecurity.aesEncrypt("q12345678", hexKey: "8d22415838638cbe579b1017c6f1738bc453b569ef38a23ddc08d56d357904a9", hexIv: "0000000000000000")
        
        return true
    }

    override func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    override func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        }
        
        //注册后台任务
        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        })
    }

    override func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    override func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    override func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Background play
    func registerBackgroundPlay() {
        //DHBackgroundRunner.shared.openRunner = true
        //DHBackgroundRunnerPlus.shared.openRunner = true
    }
    
    //MARK: - Notification
    func registerNotification() {
        VKNotificationService.sharedInstance.requestAuthorization()
    }
    
    //MARK: - Log
    func initLog() {
        //直连调试模式下不开启日志
  
        //不开启日志，即时写会有性能损耗
//        LCLogManager.shareInstance()?.startFileLog()
//        LCLogManager.shareInstance()?.maxLogSize = 10
//        LCLogManager.shareInstance()?.isCycle = true
    }

    //MARK: WeexSDK
    func initWeexSDK() {
//        WXAppConfiguration.setAppGroup("DemoApp")
//        WXSDKEngine.initSDKEnvironment()
//        
//        WXLog.setLogLevel(.off)
    }
    
    //MARK: BeeHive
    func initBeeHive(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        BHContext.shareInstance().application = application
        BHContext.shareInstance().launchOptions = launchOptions
        BHContext.shareInstance().moduleConfigName = "ModuleList" //Module.plist，默认为BeeHive.bundle/BeeHive.plist
        BHContext.shareInstance().serviceConfigName = "ServiceList"
        BeeHive.shareInstance().enableException = true
        
        //注册模块，并进行加载全部
        BeeHive.registerDynamicModule(WidgetsModule.classForCoder())
        BeeHive.shareInstance().context = BHContext.shareInstance()
    }
    
    //MARK: DoraemonKit
    func initDoraemonKit() {
        #if DEBUG
        DoraemonManager.shareInstance().install(withPid: "7a1157650580d4b3c0acdbfba439e243")
        #endif
    }
    
    //MARK: VoIP
    func setupVoIP() {
        let configuration = CXProviderConfiguration(localizedName: "CallKit Quickstart")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportsVideo = true
        configuration.supportedHandleTypes = [.generic, .phoneNumber, .emailAddress]
        
        if let callKitIcon = UIImage(named: "tabbar_cydia") {
            configuration.iconTemplateImageData = callKitIcon.pngData()
        }
        
        //let callKitProvider = CXProvider(configuration: configuration)
    }
}

