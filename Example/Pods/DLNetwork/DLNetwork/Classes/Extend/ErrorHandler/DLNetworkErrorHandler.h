//
//  DLNetworkErrorHandler.h
//  Pods
//
//  Created by yjj on 2017/5/24.
//
//  网络请求错误处理公共类

#import <Foundation/Foundation.h>
/**
 网络请求错误处理
 */
typedef NS_ENUM(NSUInteger, DLNetworkErrorHandlerOptions) {
    //  默认处理方式 以Alert的方式显示错误 在上一个Alert没有消失的时候忽略本次Alert
    DLNetworkErrorHandlerOptionsMark = 0,
    //  强制显示Alert
    DLNetworkErrorHandlerOptionsAlert,
    //  强制显示Toast
    DLNetworkErrorHandlerOptionsToast
    
};


@interface DLNetworkErrorHandler : NSObject

/**
 实例化网络错误处理类

 @return 实例
 */
+ (instancetype)defaultHandler;


/**
 处理网络错误

 @param error 错误
 @param errorOption 以什么方式处理错误：参考 DLNetworkErrorHandlerHeader
 */
- (void)dealNetworkError:(NSError *)error option:(DLNetworkErrorHandlerOptions)errorOption;

@end
