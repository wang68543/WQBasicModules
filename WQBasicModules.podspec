#
# Be sure to run `pod lib lint WQBasicModules.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WQBasicModules'
  s.version          = '0.2.7'
  s.summary          = 'Swift 常用的一些分类以及工具集合'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
日常常用的功能集合, 持续优化更新(包含扩展，工具类以及一些基础框架)
                       DESC

  s.homepage         = 'https://github.com/wang68543/WQBasicModules'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wang68543' => 'wang68543@163.com' }
  s.source           = { :git => 'https://github.com/wang68543/WQBasicModules.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.source_files  = 'WQBasicModules/Classes/WQBasicModules.h'
  #  s.swift_versions = ['3.0', '4.0', '4.2', '5.0']
  # s.swift_version = '4.2'
    s.subspec 'Animation' do |ss|
        ss.subspec 'Layer' do |sss|
            sss.source_files = 'WQBasicModules/Classes/Animation/Layer/*.swift'
        end
        ss.subspec 'Views' do |sss|
            sss.dependency 'WQBasicModules/Animation/Layer'
            sss.source_files = 'WQBasicModules/Classes/Animation/Views/*.swift'
        end
        ss.subspec 'Transitioning' do |sss|
            sss.dependency 'WQBasicModules/Extensions/Module'
            sss.dependency 'WQBasicModules/UI/Help'
            sss.source_files = 'WQBasicModules/Classes/Animation/Transitioning/*.swift'
        end
    end

    s.subspec 'Extensions' do |ss|
        ss.subspec 'Module' do |sss|
            sss.source_files = 'WQBasicModules/Classes/Extensions/Module/*.swift'
        end
        ss.subspec 'UIKit' do |sss|
            sss.source_files = 'WQBasicModules/Classes/Extensions/UIKit/*.swift'
        end
        ss.subspec 'Foundation' do |sss|
            sss.source_files = 'WQBasicModules/Classes/Extensions/Foundation/*.{swift,h,m}'
        end
        ss.subspec 'Date' do |sss|
            sss.dependency 'WQBasicModules/Extensions/Foundation'
            sss.source_files = 'WQBasicModules/Classes/Extensions/Date/*.swift'
        end
        ss.subspec 'String' do |sss|
            sss.source_files = 'WQBasicModules/Classes/Extensions/String/*.{swift,h,m}'
        end
    end
    
     s.subspec 'Tool' do |ss|
         ss.subspec 'Cache' do |sss|
             sss.source_files = 'WQBasicModules/Classes/Tool/Cache/*.swift'
         end
         ss.subspec 'JsonCodable' do |sss|
            sss.source_files = 'WQBasicModules/Classes/Tool/JsonCodable/*.swift'
         end
     end
     
     s.subspec 'UI' do |ss|
         ss.subspec 'Custom' do |sss|
             sss.dependency 'WQBasicModules/Extensions/Module'
             sss.source_files = 'WQBasicModules/Classes/UI/Custom/*.swift'
         end
         ss.subspec 'Function' do |sss|
             sss.source_files = 'WQBasicModules/Classes/UI/Function/*.swift'
         end
         ss.subspec 'Help' do |sss|
             sss.dependency 'WQBasicModules/Extensions/Module'
             ss.resource = 'WQBasicModules/Classes/Resources/WQUIBundle.bundle'
             sss.source_files = 'WQBasicModules/Classes/UI/Help/*.swift'
         end
         ss.subspec 'FlowLayout' do |sss|
             sss.source_files = 'WQBasicModules/Classes/UI/FlowLayout/*.swift'
         end
     end
end
