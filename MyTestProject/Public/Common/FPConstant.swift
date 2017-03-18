//
//  FPConstant.swift
//  FPSwift
//
//  Created by iblue on 16/7/10.
//  Copyright © 2016年 iblue. All rights reserved.
//

import UIKit

//MARK: 测试相关

/// 支付测试
let FP_TEST_PAYMODE: Bool = false

/// 调试模式
let FP_DEBUG_MODE: Bool = false

/// 设置密码时加密模式
let FP_TEST_PWDENCRYPT_MODE: Bool = true

//MARK: 其他
/// 手机相关
let FP_SCREEN_WIDTH   = UIScreen.main.bounds.width
let FP_SCREEN_HEIGHT  = UIScreen.main.bounds.height
let FP_NAVI_HEIGHT    = CGFloat(64)
let FP_IOSVERSION = (UIDevice.current.systemVersion as NSString).floatValue

/// 日期格式化形式
let FP_DATEFORMAT_ALL       = "yyyy-MM-dd HH:mm:ss"
let FP_DATEFORMAT_HOUR      = "HH:mm:ss"
let FP_DATEFORMAT_MINITUE   = "mm:ss"
let FP_DATEFORMAT_YEAR      = "yyyy-MM-dd"
let FP_SECONDS_DAY          = TimeInterval(24*3600)

/// 输入限制
let FP_EMOJI = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
let FP_SPACE = "[//s//p{Zs}]"
let FP_ILLEGALCHAR = "[`~!#$%^&*+=|{}()':;'@,\\[\\]<>/?~！#¥%⋯⋯&*（）——+|{}【】‘；：\"”“’。，、？]"
let FP_NUMBERS = "0123456789"


/// 视图相关
let FP_SEPARATOR_MARGIN = CGFloat(10)

/// 服务电话
let FP_SERVICE_CALL_NUMBER = "0571-86618268"
let FP_SERVICE_CALL_URL = "telprompt://\(FP_SERVICE_CALL_NUMBER)"

/// 第三方账号信息
let FP_PAY_SCHEME = "com.zjfunday.heju"
let FP_WECHAT_APPID = "wxfd034d165bd308a0"
let FP_WECHAT_SECRET = "fc51fc68cf8bfbaf2e325c9d271607eb"
let FP_GT_APPID: String = "Bxia8xMCh8A6AAo5rP0Q19"
let FP_GT_APPKEY: String = "RxeNEnPYIt7XxpMgn9wJE8"
let FP_GT_APPSECRET: String = "0ydeRtFVn37fdjHQdIULe6"

/// 业务相关
let FP_PAY_PERIOD_ARRAY = ["一季度", "半年", "一年"]
let FP_SQUARE = "m²"
let FP_RMB = "￥"

/// 通知
let FP_NOTIFY_PAYRESULT: NSNotification.Name = NSNotification.Name(rawValue: "PayResult") //支付结果

/// RUNTIME数据缓存 
let FP_RUNTIME_ELECTRIC_FEE = "kRunTimeElectricFee"
let FP_RUNTIME_ELECTRIC_READINGS = "kRunTimeElectricReadings"


/// Inline functions
func fp_testDeinit(_ aClass: AnyObject) {
    debugPrint("💔💔 \(NSStringFromClass(aClass.classForCoder)) deinit 💔💔" )
}
