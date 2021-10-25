## mPaaS Pods Begin
#plugin "cocoapods-mPaaS"
#source "https://code.aliyun.com/mpaas-public/podspecs.git"
#mPaaS_baseline '10.1.32'  # 请将 x.x.x 替换成真实基线版本
#mPaaS_version_code 20   # This line is maintained by MPaaS plugin automatically. Please don't modify.
## mPaaS Pods End
# ---------------------------------------------------------------------
source 'https://github.com/CocoaPods/Specs.git'
source 'https://yfgitlab.dahuatech.com/PublicCloud/APP-Com/LCPrivateCocoaPods.git'
source "https://github.com/TuyaInc/TuyaPublicSpecs.git"

use_frameworks!

target 'MyTestProject' do
  
  platform :ios, '10.0'
  
#  #指定Pods Target的架构
#  post_install do |installer|
#    installer.pods_project.targets.each do |target|
#      target.build_configurations.each do |config|
#        config.build_settings['ARCHS'] = 'arm64'
#        config.build_settings['VALID_ARCHS'] = 'arm64'
##        config.build_settings['SWIFT_VERSION'] = '4.0'
#      end
#    end
#  end
  
  #消除第三方库的警告
  inhibit_all_warnings!
  
  pod 'pop'
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift5'
#  pod 'RAMAnimatedTabBarController', '~> 3.5.0'
  pod 'Alamofire', '~> 4.7.3'
  
  pod 'MBProgressHUD', '~> 0.9.2'
  pod 'SDWebImage', '~> 3.8.1'
  pod 'Masonry', '0.6.3'
  pod 'BeeHive', '~> 1.5.1'
  pod 'MGJRouter', '~> 0.9.3'
  pod 'CocoaSecurity', '~> 1.2.4'
  pod 'DoraemonKit', '~> 3.0.2'
  
  #  pod 'WeexSDK', '0.11.0'
  
#  #share sdk，具体见http://wiki.mob.com/使用cocoapods集成sharesdk/
#  #主模块(必须)
#  pod 'ShareSDK3', :git => 'https://git.oschina.net/MobClub/ShareSDK-for-iOS.git'
#  pod 'MOBFoundation'
#  
#  #平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
#  pod 'ShareSDK3/ShareSDKPlatforms/QQ', :git => 'https://git.oschina.net/MobClub/ShareSDK-for-iOS.git'
#  pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo', :git => 'https://git.oschina.net/MobClub/ShareSDK-for-iOS.git'
#  pod 'ShareSDK3/ShareSDKPlatforms/WeChat', :git => 'https://git.oschina.net/MobClub/ShareSDK-for-iOS.git'

  pod 'DHDateFormatter'
  pod 'LCLogManager'
  
  #本地Pods模块
  pod 'DHSandboxTool'
  
#  pod 'LC-SnapKit', '= 5.4'
  pod 'WCDBSwift', '~> 1.0.2'
  pod 'SnapKit', '~> 5.0.1'
  
  
  #阿里mPaaS
  #mPaaS_pod "mPaaS_ScanCode"
  
#  pod 'TuyaSmartActivatorBizBundle'
  
end
