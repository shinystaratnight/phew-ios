# Uncomment the next line to define a global platform for your project
source 'https://cdn.cocoapods.org/'

platform :ios, '12.0'

target 'Phew' do
  # Comment the next line if you don't want to use dynamic frameworks
  inhibit_all_warnings!
  use_frameworks!
  
  # Pods for Phew
  pod 'IQKeyboardManagerSwift'
  pod 'SDWebImage'
  pod 'Alamofire', '~> 4.9.1'
  
#  pod 'Firebase/Core'
  pod 'FirebaseMessaging'
#  pod 'Firebase/Messaging'
 # pod 'FirebaseAnalytics', '~> 1.9.3'
#  pod 'Firebase/Performance'
  pod 'MOLH'
  pod 'NVActivityIndicatorView', '~> 4.8.0'
 # pod 'Firebase'
  pod "ESTabBarController-swift"
  
  pod 'JJFloatingActionButton'
  pod 'Cache', '~> 5.3.0'
  pod 'Socket.IO-Client-Swift'
  
  pod 'GoogleSignIn' , '~> 5.0.2', :inhibit_warnings => true
  pod 'Firebase/Auth'
#  pod 'DataCache'
  pod 'FLEX', :configurations => ['Debug']


  post_install do | installer |
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
          config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
#          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
          config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
          config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
      end
      installer.pods_project.build_configurations.each do |config|
        config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
      end
  end
end
