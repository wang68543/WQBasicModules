# WQBasicModules

[![CI Status](https://img.shields.io/travis/wang68543/WQBasicModules.svg?style=flat)](https://travis-ci.org/github/wang68543/WQBasicModules)
[![Version](https://img.shields.io/cocoapods/v/WQBasicModules.svg?style=flat)](http://cocoapods.org/pods/WQBasicModules)
[![License](https://img.shields.io/cocoapods/l/WQBasicModules.svg?style=flat)](http://cocoapods.org/pods/WQBasicModules)
[![Platform](https://img.shields.io/cocoapods/p/WQBasicModules.svg?style=flat)](http://cocoapods.org/pods/WQBasicModules)

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
>说明:这个库是日常工作中累积的工具类以及总结封装的一些使用工具,所有的模块应用于以往的项目,后续也会不断优化以及新增.


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
