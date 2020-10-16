# Uncomment the next line to define a global platform for your project
platform :ios, '11.4'

target 'SC' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SC
  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  pod 'Firebase/Core'
  pod 'Firebase/AdMob'
  pod 'SwiftLint'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.4'
    end
  end
end