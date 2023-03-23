#
# Be sure to run `pod lib lint VNBase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VNBase'
  s.version          = '0.4.62'
  s.summary          = 'Simple MVVM helper'
  s.swift_version 	 = '5.0'
  s.description      = <<-DESC
TODO: I should add some description later =)
                       DESC

  s.homepage         = 'https://github.com/teanet/VNBase'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'teanet' => 'tea.net@me.com' }
  s.source           = { :git => 'https://github.com/teanet/VNBase.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/teanet'

  s.ios.deployment_target = '11.0'
  s.ios.source_files = 'VNBase/Classes/**/*'
  # s.resource_bundles = {
  #   'VNBase' => ['VNBase/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.ios.frameworks = 'UIKit'
  s.ios.dependency 'SnapKit'
  s.ios.dependency 'VNEssential'
  s.ios.dependency 'VNHandlers'

end