# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
# source 'https://github.com/CocoaPods/Specs.git'

target 'Telie' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  inhibit_all_warnings!

  # Pods for Telie

	# Facebook Authentication
 	pod 'FacebookSDK'
 	pod 'FacebookSDK/LoginKit'
 	pod 'FacebookSDK/ShareKit'
 	pod 'FacebookSDK/PlacesKit'
 	pod 'FBSDKMessengerShareKit'

	# Networking
    	pod 'Alamofire', '~> 5.2.1'
	pod 'Wormholy', :configurations => ['Dev Debug']

	# Analytics
	pod 'Firebase/Analytics'

	# User Interface
    	pod 'IQKeyboardManagerSwift'
    	pod 'SnapKit'
	pod 'SPPermissions/Notification'
	pod 'Siren'

	# Data Loading
	pod 'NotificationBannerSwift', '~> 3.0.0'
	pod 'SkeletonView'
	pod 'Kingfisher', '~> 7.0'
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
