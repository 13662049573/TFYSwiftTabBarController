
Pod::Spec.new do |spec|

  spec.name         = "TFYSwiftTabbarKit"

  spec.version      = "2.0.6"

  spec.summary      = "Swift版的tabbarController 满足基本使用，方便快捷。最低支持iOS 12  Swift5 以上"

  spec.description  = <<-DESC
  Swift版的tabbarController 满足基本使用，方便快捷。最低支持iOS 12  Swift5 以上
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFYSwiftTabBarController"

  spec.license      = "MIT"

  spec.author       = { "田风有" => "420144542@qq.com" }
 
  spec.platform     = :ios, "12.0"

  spec.swift_version = '5.0'

  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  spec.source       = { :git => "https://github.com/13662049573/TFYSwiftTabBarController.git", :tag => spec.version }

  spec.source_files  = "TFYSwiftTabBarController/TFYSwiftTabbarKit/*.{swift}"
 
  spec.requires_arc = true

end
