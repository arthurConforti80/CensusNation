# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'CensusUSA' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire', '5.8.1'

  # Pods for CensusUSA

  target 'CensusUSATests' do
    inherit! :search_paths
    pod 'OHHTTPStubs'	
    # Pods for testing
  end

  target 'CensusUSAUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end


