//
//  DLNetrowkMessage.h
//  Pods
//
//  Created by yjj on 2017/7/19.
//
//

#import <Foundation/Foundation.h>

@interface DLNetrowkMessage : NSObject

/**
 获取本地化翻译的文本

 @param  key Key
 @return 本地化后的文案
 */
+ (NSString *)messageWithKey:(NSString *)key;


/**
 获取网络错误编码对应的错误描述

 @param  code 错误编码
 @return 错误描述
 */
+ (NSString *)urlErorrMessageWithCode:(NSInteger)code;

@end
