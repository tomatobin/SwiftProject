source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!


##SVN自定义组件路径
utility_path = 'http://10.6.5.2/svn/MobileMonitor/MobileDirectMonitor/CommonModule/iCommonModule/ToolSet/Utility/Trunk/'
widgets_path = 'http://10.6.5.2/svn/MobileMonitor/MobileDirectMonitor/CommonModule/iCommonModule/ToolSet/Widgets/Trunk/'
commmon_module_path = 'http://10.6.5.2/svn/MobileMonitor/MobileDirectMonitor/MobileCommonModule/Trunk/ios/'

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
  pod 'SnapKit'
  
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

  pod 'DHDateFormatter', :svn => utility_path + 'DHDateFormatter'
  pod 'LCLogManager', :svn => utility_path + 'LCLogManager'
  
  #本地Pods模块
  pod 'DHSandboxTool', :path => './Depend/DHSandboxTool'
  
end
