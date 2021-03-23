# WQBasicModules
[![Platform](https://img.shields.io/cocoapods/p/WQBasicModules.svg?style=flat)](http://cocoapods.org/pods/WQBasicModules)
[![Swift Version](https://img.shields.io/badge/swift-5.0-blue.svg)](https://swift.org/)
[![Version](https://img.shields.io/cocoapods/v/WQBasicModules.svg?style=flat)](http://cocoapods.org/pods/WQBasicModules)
[![support](https://img.shields.io/badge/support-ios%209%2B-blue.svg)](#) 
[![CI Status](https://img.shields.io/travis/wang68543/WQBasicModules.svg?style=flat)](https://travis-ci.org/github/wang68543/WQBasicModules)
[![License](https://img.shields.io/cocoapods/l/WQBasicModules.svg?style=flat)](http://cocoapods.org/pods/WQBasicModules)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

WQBasicModules is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WQBasicModules'
```
主要功能
================
>说明:这个库是日常工作中累积的工具类以及总结封装的一些使用工具,所有的模块都和公司小伙伴们实践应用于项目中,后续也会不断优化以及新增.

![](snapshots/module.jpg '目录结构')

* Animation

    封装了UIView的基础动画,便于开发者开始以及结束移除动画
* Extensions

    累积的一些项目中经常用到并且比较好用的扩展, 例如日期、字符串及UIKit等
* Function

    用于收集日常常用的一些UI功能模块
* FunModule

    优化封装App中一些常用的业务逻辑,例如选择单张照片、本地化等
* Modal

    封装的弹窗功能,支持高度自定义的弹窗,并且提供alert、actionSheet、pop以及平移展示的便利显示接口
* Tool

    提供一些日常高频率使用的工具类,例如:自定义对象的序列化以及便捷存储
* UI

    封装以及自定义一些日常App中需要用到但是系统又没有便利的直接使用的UI
* More

    待更新...
#
可能遇到的问题解决方案 
================
1. 当多个target使用不同的subspec的时候,请将podfile中的
```ruby 
use_frameworks! 改为 use_modular_headers!
```
2. 旧版本的Modal弹窗需要单独引入 
```ruby 
 pod 'WQBasicModules/Animation/Transitioning' 
```
