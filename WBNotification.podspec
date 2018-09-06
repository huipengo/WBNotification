#
# Be sure to run `pod lib lint WBNotification.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WBNotification'
  s.version          = '0.1.0'
  s.summary          = '封装系统推送通知；device token 转字符串；推送消息点击一条消失一条，而不是点击全部消失；点击打开系统设置推送通知界面； 方便简洁.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
一行代码注册推送通知，适配iOS8+，包含 device token 转字符串方法；判断APP是否允许推送方法；推送消息点一条消失一条，跳转系统设置推送通知界面；
                       DESC

  s.homepage         = 'https://github.com/huipengo/WBNotification'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '彭辉' => 'penghui_only@163.com' }
  s.source           = { :git => 'https://github.com/huipengo/WBNotification.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Pod/Classes/*.{h,m}'
  
  # s.resource_bundles = {
  #   'WBNotification' => ['WBNotification/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
