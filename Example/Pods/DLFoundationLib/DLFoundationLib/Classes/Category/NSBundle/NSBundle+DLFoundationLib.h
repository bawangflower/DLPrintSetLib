//
//  NSBundle+DLFoundationLib.h
//  Pods
//
//  Created by yjj on 2017/6/29.
//
//

#import <Foundation/Foundation.h>

#define DLLocalizedString(key) [NSBundle dl_localizedStringForKey:(key) value:@""]

@interface NSBundle (DLFoundationLib)


/**
 获取FoundationLib的Bundle

 @return Bundle
 */
+ (instancetype)dl_fundationLibBundle;


/**
 获取图片的Bundle

 @return Bundle
 */
+ (instancetype)dl_fundationLibImageBundle;


/**
 获取本地化的语言

 @param key key
 @return 本地化语音
 */
+ (NSString *)dl_localizedStringForKey:(NSString *)key value:(NSString *)value;

@end
