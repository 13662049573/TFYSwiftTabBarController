
platform :ios, '15.0'
install! 'cocoapods', :warn_for_unused_master_specs_repo => false

target 'TFYSwiftTabBarController' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'SnapKit'
  pod 'TFYSwiftNavigationKit'
  pod 'TFYSwiftCategoryUtil'
  pod 'lottie-ios'

  target 'TFYSwiftTabBarControllerTests' do
    inherit! :search_paths
  end

end

post_install do |pi|
  pi.pods_project.build_configurations.each do |config|
    config.build_settings['LM_SKIP_METADATA_EXTRACTION'] = 'YES'
  end

  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end

  navigation_controller = File.join(__dir__, 'Pods/TFYSwiftNavigationKit/TFYSwiftNavigationController/TFYSwiftNavigationKit/TFYSwiftNavigationController.swift')
  source = File.read(navigation_controller)
  source.sub!("@available(iOS 15.0, *)\npublic class TFYSwiftNavigationController", "public class TFYSwiftNavigationController")
  File.chmod(0644, navigation_controller)
  File.write(navigation_controller, source)
end
