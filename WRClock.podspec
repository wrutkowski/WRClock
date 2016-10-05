#
# Be sure to run `pod lib lint WRClock.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WRClock'
  s.version          = '0.1.0'
  s.summary          = 'Analog Real Time Clock written in Swift 3'
  s.description      = <<-DESC
Analog Real Time Clock written in Swift 3
Simple, highly customizable
                       DESC
  s.homepage         = 'https://github.com/wrutkowski/WRClock'
  s.screenshots     = 'https://raw.githubusercontent.com/wrutkowski/WRClock/master/Assets/WRClock.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wojciech Rutkowski' => 'me@wojciech-rutkowski.com' }
  s.source           = { :git => 'https://github.com/wrutkowski/WRClock.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/WojRutkowski'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WRClock/Classes/**/*'

end
