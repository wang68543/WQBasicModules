# WQBasicModules

[![CI Status](https://img.shields.io/travis/wang68543/WQBasicModules.svg?style=flat)](https://travis-ci.org/github/wang68543/WQBasicModules)
[![Version](https://img.shields.io/cocoapods/v/WQBasicModules.svg?style=flat)](http://cocoapods.org/pods/WQBasicModules)
[![License](https://img.shields.io/cocoapods/l/WQBasicModules.svg?style=flat)](http://cocoapods.org/pods/WQBasicModules)
[![Platform](https://img.shields.io/cocoapods/p/WQBasicModules.svg?style=flat)](http://cocoapods.org/pods/WQBasicModules)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

WQBasicModules is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WQBasicModules'
```

## Author
 wang68543@163.com

## License

WQBasicModules is available under the MIT license. See the LICENSE file for more info.
# WQBasicModules

### issue
当多个target使用不同的subspec的时候,请将podfile中的
```ruby 
1. use_frameworks! 改为 use_modular_headers!
```
2. 旧版本的弹窗需要单独引入 
```ruby 
    pod 'WQBasicModules/Animation/Transitioning' 
```
