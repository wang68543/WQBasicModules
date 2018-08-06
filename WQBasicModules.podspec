#
# Be sure to run `pod lib lint WQBasicModules.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WQBasicModules'
  s.version          = '0.1.4'
  s.summary          = 'Swift 常用的一些分类以及工具集合'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
主要是讲之前的Objective-c版本的[WQBasicComponents](https://github.com/wang68543/WQBasicComponents.git) 转为Swift 版本
                       DESC

  s.homepage         = 'https://github.com/wang68543/WQBasicModules'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wang68543' => 'wang68543@163.com' }
  s.source           = { :git => 'https://github.com/wang68543/WQBasicModules.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  	s.ios.deployment_target = '8.0'
 	s.source_files  = "WQBasicModules/Classes/WQBasicModules.h"
 
    s.subspec 'WQExtensions' do |ss|
        ss.subspec 'WQUIKitExtensions' do |sss|
            sss.source_files = 'WQBasicModules/Classes/WQExtensions/WQUIKitExtensions/*.swift'
        end
        ss.subspec 'WQFoundationExtensions' do |sss|
            sss.source_files = 'WQBasicModules/Classes/WQExtensions/WQFoundationExtensions/*.swift'
        end
        ss.subspec 'WQDateExtensions' do |sss|
            sss.dependency 'WQBasicModules/WQExtensions/WQFoundationExtensions'
            sss.source_files = 'WQBasicModules/Classes/WQExtensions/WQDateExtensions/*.swift'
        end
        ss.subspec 'WQStringExtensions' do |sss| 
            sss.source_files = 'WQBasicModules/Classes/WQExtensions/WQStringExtensions/*.{swift,h,m}'
        end
    end
       
     s.subspec 'WQHelpTool' do |ss|
 #        ss.subspec 'WQSingle' do |sss|
 #           sss.source_files = 'WQBasicModules/Classes/WQHelpTool/WQSingle/*.swift'
 #        end
         ss.subspec 'WQJsonCodable' do |sss|
         	# sss.frameworks = 'CommonCrypto'
         	sss.source_files = 'WQBasicModules/Classes/WQHelpTool/WQJsonCodable/*.swift'
         end
     end
     s.subspec 'WQCustomUI' do |ss|
         ss.source_files = 'WQBasicModules/Classes/WQCustomUI/*.swift'
     end
 # s.public_header_files = 'Pod/Classes/**/*.h'
 # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
