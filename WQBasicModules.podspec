#
# Be sure to run `pod lib lint WQBasicModules.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WQBasicModules'
  s.version          = '0.2.1'
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
 	s.source_files  = 'WQBasicModules/Classes/WQBasicModules.h'
 
    s.subspec 'WQExtensionModule' do |ss|
        ss.source_files = 'WQBasicModules/Classes/WQExtensionModule/*.swift'
    end
  	s.subspec 'WQAnimation' do |ss|
        ss.subspec 'Layer' do |sss|
            sss.source_files = 'WQBasicModules/Classes/WQAnimation/Layer/*.swift'
        end
        ss.subspec 'Views' do |sss|
            sss.dependency 'WQBasicModules/WQAnimation/Layer'
            sss.source_files = 'WQBasicModules/Classes/WQAnimation/Views/*.swift'
        end
        ss.subspec 'Transitioning' do |sss| 
            sss.dependency 'WQBasicModules/WQExtensionModule'
            sss.source_files = 'WQBasicModules/Classes/WQAnimation/Transitioning/*.swift'
        end
    end
    s.subspec 'WQExtensions' do |ss|
        ss.subspec 'WQUIKit' do |sss|
            sss.source_files = 'WQBasicModules/Classes/WQExtensions/WQUIKit/*.swift'
        end
        ss.subspec 'WQFoundation' do |sss|
            sss.source_files = 'WQBasicModules/Classes/WQExtensions/WQFoundation/*.{swift,h,m}'
        end
        ss.subspec 'WQDate' do |sss|
            sss.dependency 'WQBasicModules/WQExtensions/WQFoundation'
            sss.source_files = 'WQBasicModules/Classes/WQExtensions/WQDate/*.swift'
        end
        ss.subspec 'WQString' do |sss|
            sss.source_files = 'WQBasicModules/Classes/WQExtensions/WQString/*.{swift,h,m}'
        end
    end
       
     s.subspec 'WQHelpTool' do |ss|
 #        ss.subspec 'WQSingle' do |sss|
 #           sss.source_files = 'WQBasicModules/Classes/WQHelpTool/WQSingle/*.swift'
 #        end
         ss.subspec 'WQCache' do |sss|
             sss.source_files = 'WQBasicModules/Classes/WQHelpTool/WQCache/*.swift'
         end
         ss.subspec 'WQJsonCodable' do |sss|
         	sss.source_files = 'WQBasicModules/Classes/WQHelpTool/WQJsonCodable/*.swift'
         end
     end
     s.subspec 'WQUI' do |ss|
         ss.subspec 'Custom' do |sss|
             sss.source_files = 'WQBasicModules/Classes/WQUI/Custom/*.swift'
         end
         ss.subspec 'Function' do |sss|
             sss.source_files = 'WQBasicModules/Classes/WQUI/Function/*.swift'
         end
         ss.subspec 'Help' do |sss|
             ss.resource = 'WQBasicModules/Classes/WQUI/Help/WQUIBundle.bundle'
             sss.source_files = 'WQBasicModules/Classes/WQUI/Help/*.swift'
         end
         ss.subspec 'FlowLayout' do |sss| 
             sss.source_files = 'WQBasicModules/Classes/WQUI/FlowLayout/*.swift'
         end
     end
 # s.public_header_files = 'Pod/Classes/**/*.h'
 # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
