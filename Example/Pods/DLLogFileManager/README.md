# DLLogFileManager

[![CI Status](http://img.shields.io/travis/qq912276337/DLLogFileManager.svg?style=flat)](https://travis-ci.org/qq912276337/DLLogFileManager)
[![Version](https://img.shields.io/cocoapods/v/DLLogFileManager.svg?style=flat)](http://cocoapods.org/pods/DLLogFileManager)
[![License](https://img.shields.io/cocoapods/l/DLLogFileManager.svg?style=flat)](http://cocoapods.org/pods/DLLogFileManager)
[![Platform](https://img.shields.io/cocoapods/p/DLLogFileManager.svg?style=flat)](http://cocoapods.org/pods/DLLogFileManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DLLogFileManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DLLogFileManager"
```

## Use

* import 'DLLogFileManager/DLLogHeader'
* [DLLogConfigure sharedConfigure].productType = @"assistant";
* [DLLogConfigure sharedConfigure].uploadAddress = @"http://log.hzdlsoft.com:8081/clog/clog";;
* [[DLLogManager sharedManager] start];
* DLLog("all log will write to logfile ")

## Author

qq912276337, smlsjq@163.com

## License

DLLogFileManager is available under the MIT license. See the LICENSE file for more info.
