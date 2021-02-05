use_modular_headers!
platform :ios, '10.0'

target 'VNBase_Example' do
  project 'Example/VNBase.xcodeproj'
  pod 'VNBase', :path => './'
  pod 'SwiftLint'

  target 'VNBase_Tests' do
    inherit! :search_paths
  end
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|

			config.build_settings['SWIFT_VERSION'] = '5.0'
			if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 10.0
				config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
			end
		end
	end

end
