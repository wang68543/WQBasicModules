#
# Be sure to run `pod lib lint WQBasicModules.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WQBasicModules'
  s.version          = '0.4.2'
  s.summary          = 'Swift 常用的一些分类以及工具集合'
 

  s.description      = <<-DESC
日常常用的功能集合, 持续优化更新(包含扩展，工具类以及一些基础框架)
                       DESC

  s.homepage         = 'https://github.com/wang68543/WQBasicModules' 
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wang68543' => 'wang68543@163.com' }
  s.source           = { :git => 'https://github.com/wang68543/WQBasicModules.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
#  s.source_files  = 'Sources/WQBasicModules.h'
#  s.swift_version = '4.2'
  s.swift_versions = ['4.0', '4.2', '5.0', '5.1' ,'5.2', '5.3','5.4','5.5']
  s.default_subspec = 'Core'
#  s.source_files = 'Sources/**/**/*.swift'
  s.requires_arc = true
  
  s.dependency 'SwifterSwift', '~>5.2.0'
  
  s.subspec 'Core' do |ss|
      ss.dependency 'WQBasicModules/Modal'
      ss.dependency 'WQBasicModules/Animation/Layer'
      ss.dependency 'WQBasicModules/Animation/Views'
      ss.dependency 'WQBasicModules/Extensions'
      ss.dependency 'WQBasicModules/Tool'
      ss.dependency 'WQBasicModules/UI'
  end
  
  
  s.subspec 'AppExtension' do |ss|
      ss.dependency 'WQBasicModules/Extensions'
      ss.dependency 'WQBasicModules/Tool'
      #可以使用此属性替代全局
#      ss.ios.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  end
  
  
#  s.subspec 'Beta' do |ss| 
#  end
  
  
  s.subspec 'FunModule' do |ss|
      #选择图片 适用于直接使用系统API的选择
      ss.subspec 'ImagePicker' do |sss|
          sss.source_files = 'Sources/FunModule/ImagePicker/*.swift'
      end
      ss.subspec 'Localize' do |sss|
          sss.source_files = 'Sources/FunModule/Localize/*.swift'
      end
      ss.subspec 'Bluetooth' do |sss|
          sss.source_files = 'Sources/FunModule/Bluetooth/*.swift'
      end
      ss.subspec 'AppOptimize' do |sss|
          sss.source_files = 'Sources/FunModule/AppOptimize/*.swift'
      end
      ss.subspec 'NoteBook' do |sss|
#          sss.resource_bundles = { 'NoteBook' => ['Sources/FunModule/NoteBook/*.html'] }
          sss.resources = ['Sources/FunModule/NoteBook/*.html']
          sss.source_files = 'Sources/FunModule/NoteBook/*.swift'
      end
  end
  
#  s.subspec 'Function' do |ss|
#      ss.subspec 'PageViewController' do |sss|
#          sss.source_files = 'Sources/Function/PageViewController/*.swift'
#      end
#  end
    s.subspec 'Animation' do |ss|
        ss.subspec 'Layer' do |sss|
            sss.source_files = 'Sources/Animation/Layer/*.swift'
        end
        ss.subspec 'Views' do |sss|
            sss.dependency 'WQBasicModules/Animation/Layer'
            sss.source_files = 'Sources/Animation/Views/*.swift'
        end
        ss.subspec 'Transitioning' do |sss|
            sss.dependency 'WQBasicModules/Extensions/Module'
            sss.dependency 'WQBasicModules/UI/Help'
            sss.source_files = 'Sources/Animation/Transitioning/*.swift'
        end

    end
    #自定义各式风格的弹窗
    s.subspec 'Modal' do |ss|
        ss.dependency 'WQBasicModules/UI/Help'
        ss.dependency 'WQBasicModules/Extensions/Foundation'
        ss.dependency 'WQBasicModules/Extensions/Module'
        ss.source_files = 'Sources/Modal/**/*.swift'
    end
    
    s.subspec 'Extensions' do |ss|
        ss.subspec 'Module' do |sss|
            sss.source_files = 'Sources/Extensions/Module/*.swift'
        end
        ss.subspec 'CoreGrapics' do |sss|
            sss.source_files = 'Sources/Extensions/CoreGrapics/*.swift'
        end
        ss.subspec 'UIKit' do |sss|
            sss.dependency 'WQBasicModules/Extensions/Module'
            sss.dependency 'WQBasicModules/Extensions/CoreGrapics'
            sss.source_files = 'Sources/Extensions/UIKit/*.swift'
        end
        ss.subspec 'Foundation' do |sss|
            sss.source_files = 'Sources/Extensions/Foundation/*.swift'
        end
        ss.subspec 'Date' do |sss|
            sss.dependency 'WQBasicModules/Extensions/Foundation'
            sss.source_files = 'Sources/Extensions/Date/*.swift'
        end
#        ss.subspec 'String' do |sss|
#            sss.source_files = 'Sources/Extensions/String/*.{swift,h,m}'
#        end
    end
    
     s.subspec 'Tool' do |ss|
         ss.subspec 'Cache' do |sss|
             sss.dependency 'WQBasicModules/Extensions/Foundation'
             sss.source_files = 'Sources/Tool/Cache/*.swift'
         end
     end
     
     s.subspec 'UI' do |ss|
         ss.subspec 'Custom' do |sss|
             sss.dependency 'WQBasicModules/Extensions/Module'
             sss.source_files = 'Sources/UI/Custom/*.swift'
         end
         ss.subspec 'Function' do |sss|
             sss.source_files = 'Sources/UI/Function/*.swift'
         end
         ss.subspec 'Help' do |sss|
             sss.dependency 'WQBasicModules/Extensions/Module'
             ss.resource = 'Sources/Resources/WQUIBundle.bundle'
             sss.source_files = 'Sources/UI/Help/*.swift'
         end
         ss.subspec 'FlowLayout' do |sss|
             sss.source_files = 'Sources/UI/FlowLayout/*.swift'
         end
         ss.subspec 'Gesture' do |sss|
             sss.source_files = 'Sources/UI/Gesture/*.swift'
         end
         ss.subspec 'Launch' do |sss|
             sss.dependency 'WQBasicModules/Extensions/Foundation'
             sss.dependency 'WQBasicModules/Extensions/UIKit'
             sss.dependency 'WQBasicModules/UI/Help'
             sss.source_files = 'Sources/UI/Launch/*.swift'
         end
     end
end
