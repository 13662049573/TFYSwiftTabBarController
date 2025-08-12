
platform :ios, '15.0'

target 'TFYSwiftTabBarController' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'SnapKit'
  pod 'TFYSwiftNavigationKit'
  pod 'TFYSwiftCategoryUtil'
  pod 'lottie-ios'

end

post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
