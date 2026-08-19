Pod::Spec.new do |spec|
  spec.name         = "TFYSwiftTabbarKit"
  spec.version      = "2.0.7"
  spec.summary      = "Swift TabBarController：中间 Plus、角标、扁平栏、Lottie、iOS 26 Liquid Glass。"
  spec.description  = <<-DESC
    CYLTabBarController 的 Swift 实现。支持中间 Plus 按钮、数字/红点角标、扁平自定义 TabBar、
    Lottie Tab 动画，以及 iOS 26 Liquid Glass。最低 iOS 15、Swift 5。
  DESC
  spec.homepage     = "https://github.com/13662049573/TFYSwiftTabBarController"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "田风有" => "420144542@qq.com" }
  spec.platform     = :ios, "15.0"
  spec.ios.deployment_target = "15.0"
  spec.swift_versions = ["5.0"]
  spec.module_name  = "TFYSwiftTabbarKit"
  spec.source       = { :git => "https://github.com/13662049573/TFYSwiftTabBarController.git", :tag => spec.version.to_s }
  spec.source_files = [
    "TFYSwiftTabBarController/TFYSwiftTabbarKit/*.{h,m,swift}",
    "TFYSwiftTabBarController/TFYSwiftTabbarKit/**/*.{h,m,swift}",
  ]
  spec.public_header_files = "TFYSwiftTabBarController/TFYSwiftTabbarKit/include/*.h"
  spec.requires_arc = true
  spec.frameworks   = "UIKit", "Foundation", "QuartzCore"
  spec.dependency "lottie-ios", ">= 4.0"
  spec.pod_target_xcconfig = {
    "SWIFT_VERSION" => "5.0",
    "DEFINES_MODULE" => "YES",
    "HEADER_SEARCH_PATHS" => "$(inherited) $(PODS_TARGET_SRCROOT)/TFYSwiftTabBarController/TFYSwiftTabbarKit/include"
  }
end
