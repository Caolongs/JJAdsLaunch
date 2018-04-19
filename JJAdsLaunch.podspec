#
# Be sure to run `pod lib lint JJAdsLaunch.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JJAdsLaunch'
  s.version          = '0.2.0'
  s.summary          = 'JJAdsLaunch.'
  s.swift_version    = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'JJAdsLaunch. simple LaunchScreen'

  s.homepage         = 'https://github.com/Caolongs/JJAdsLaunch'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Caolongs@126.com' => 'caolongs@126.com' }
  s.source           = { :git => 'https://github.com/Caolongs/JJAdsLaunch.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JJAdsLaunch/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JJAdsLaunch' => ['JJAdsLaunch/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
