use_modular_headers!

target 'VNBase_Example' do
	platform :ios, '12.0'
	project 'Example/VNBase.xcodeproj'
	pod 'VNBase', :path => './'
	pod 'VNEssential', :path => './'
	pod 'VNHandlers', :path => './'
	pod 'SwiftLint'
	pod 'SnapKit', :git => 'https://github.com/teanet/SnapKit', :branch => 'develop'

	target 'VNBase_Tests' do
		inherit! :search_paths
	end
end

target 'DemoWatch Extension' do
	platform :watchos, '5.0'
	project 'Example/VNBase.xcodeproj'
	pod 'VNEssential', :path => './'
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|

			config.build_settings['SWIFT_VERSION'] = '5.0'
			if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
				config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
			end
		end
	end

end
