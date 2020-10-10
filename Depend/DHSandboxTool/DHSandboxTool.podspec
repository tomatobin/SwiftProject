#
#  Be sure to run `pod spec lint DHScanner.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "DHSandboxTool"
  s.version      = "1.0.0"
  s.summary      = "A short description of DHSandboxTool."
  s.description  = <<-DESC
                  1.1.0
                  创建版本
                  *************************
                  DESC




  s.homepage     = "http://EXAMPLE/DHSandboxTool"

  s.license      = "MIT"
  s.author       = { "tomatobin" => "tomatobin@163.com" }
  s.platform     = :ios, "9.0"

  s.source       = { :svn => "http://10.6.5.2/svn/MobileMonitor/MobileDirectMonitor/CommonModule/iCommonModule/ToolSet/Widgets/Trunk/DHSandboxTool"}

  s.source_files = "DHSandboxTool", "DHSandboxTool/*.{swift}"
  s.public_header_files = "DHSandboxTool/DHSandboxTool.h"

  #设置是否为静态库，若设置为静态库，则s.frameworks不会添加进工程配置中
  s.static_framework = true

  s.frameworks  = "QuickLook", "Foundation"

  #资源文件
  s.resource    = "DHSandboxTool/DHSandboxTool.bundle"

  #配置Swift版本号
  s.swift_version ='5.0'

  #依赖添加：需要先在主工程中添加相应依赖
  #s.dependency "xxx"

  
end
