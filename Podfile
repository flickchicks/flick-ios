# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
# source 'https://github.com/CocoaPods/Specs.git'

# Removes deployment target info from each build target (for each pod)
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

target 'Telie' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  inhibit_all_warnings!

  # Pods for Telie

	# Facebook Authentication
 	pod 'FBSDKLoginKit'
	pod 'FBSDKCoreKit'

	# Networking
    	pod 'Alamofire', '~> 5.2.1'
	pod 'Wormholy', :configurations => ['Dev Debug']

	# User Interface
    	pod 'IQKeyboardManagerSwift' 
    	pod 'SnapKit'
	pod 'SPPermissions/Notification'

	# Data Loading
	pod 'NotificationBannerSwift', '~> 3.0.0'
	pod 'SkeletonView'
	pod 'Kingfisher', '~> 5.15.0'
	pod 'NVActivityIndicatorView'
	pod 'Hero'

  target 'TelieTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TelieUITests' do
    # Pods for testing
  end

end
