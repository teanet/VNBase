#
# Be sure to run `pod lib lint VNBase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VNBase'
  s.version          = '0.2.8'
  s.summary          = 'Simple MVVM helper'
  s.swift_version 	 = '4.2'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: I should add some description later =)
                       DESC

  s.homepage         = 'https://github.com/teanet/VNBase'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'teanet' => 'tea.net@me.com' }
  s.source           = { :git => 'https://github.com/teanet/VNBase.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/teanet'

  s.ios.deployment_target = '9.0'

  s.source_files = 'VNBase/Classes/**/*'
  
  # s.resource_bundles = {
  #   'VNBase' => ['VNBase/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'TLIndexPathTools', '~> 0.4.4'
  s.dependency 'SnapKit', '~> 4.0.1'

end

