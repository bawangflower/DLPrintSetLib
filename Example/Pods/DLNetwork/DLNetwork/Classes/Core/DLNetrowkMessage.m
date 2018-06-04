//
//  DLNetrowkMessage.m
//  Pods
//
//  Created by yjj on 2017/7/19.
//
//

#import "DLNetrowkMessage.h"

@implementation DLNetrowkMessage

/**
 获取本地化翻译的文本
 
 @param  key Key
 @return 本地化后的文案
 */
+ (NSString *)messageWithKey:(NSString *)key {
    return [[self localizedStringBundle] localizedStringForKey:key value:key table:nil];
}

/**
 获取网络错误编码对应的错误描述
 
 @param  code 错误编码
 @return 错误描述
 */
+ (NSString *)urlErorrMessageWithCode:(NSInteger)code {
    return [self messageWithKey:[self urlErrorMessageInfo][@(code)]];
}

#pragma mark - Help


/**
 获取网路错误编码对应的简体中文信息

 @return 简体中文信息
 */
+ (NSDictionary *)urlErrorMessageInfo {
    static NSDictionary *messageInfo = nil;
    if (!messageInfo) {
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
//        temp[@(NSURLErrorUnknown)]                                      = @"网络不给力"; // 未知的错误
//        temp[@(NSURLErrorCancelled)]                                    = @"网络不给力"; // 请求被取消
//        temp[@(NSURLErrorBadURL)]                                       = @"网络不给力"; // 请求的URL错误，无法启动请求
//        temp[@(NSURLErrorTimedOut)]                                     = @"网络不给力"; // 请求超时
//        temp[@(NSURLErrorUnsupportedURL)]                               = @"网络不给力"; // 不支持的URL Scheme
        temp[@(NSURLErrorCannotFindHost)]                               = @"网络不给力"; // URL的host名称无法解析，即DNS有问题
        temp[@(NSURLErrorCannotConnectToHost)]                          = @"网络不给力"; // 连接host失败
//        temp[@(NSURLErrorNetworkConnectionLost)]                        = @"网络不给力"; // 连接过程中被中断
//        temp[@(NSURLErrorDNSLookupFailed)]                              = @"网络不给力"; // 同- -1003 NSURLErrorCannotFindHost
//        temp[@(NSURLErrorHTTPTooManyRedirects)]                         = @"网络不给力"; // 重定向次数超过限制
//        temp[@(NSURLErrorResourceUnavailable)]                          = @"网络不给力"; // 无法获取所请求的资源
//        temp[@(NSURLErrorNotConnectedToInternet)]                       = @"网络不给力"; // 断网状态
//        temp[@(NSURLErrorRedirectToNonExistentLocation)]                = @"网络不给力"; // 重定向到一个不存在的位置
//        temp[@(NSURLErrorBadServerResponse)]                            = @"网络不给力"; // 服务器返回数据有误
//        temp[@(NSURLErrorUserCancelledAuthentication)]                  = @"网络不给力"; // 身份验证请求被用户取消
//        temp[@(NSURLErrorUserAuthenticationRequired)]                   = @"网络不给力"; // 访问资源需要身份验证
//        temp[@(NSURLErrorZeroByteResource)]                             = @"网络不给力"; // 服务器报告URL数据不为空，却未返回任何数据
//        temp[@(NSURLErrorCannotDecodeRawData)]                          = @"网络不给力"; // 响应数据无法解码为已知内容编码
//        temp[@(NSURLErrorCannotDecodeContentData)]                      = @"网络不给力"; // 请求数据存在未知内容编码
//        temp[@(NSURLErrorCannotParseResponse)]                          = @"网络不给力"; // 响应数据无法解析
//        temp[@(NSURLErrorAppTransportSecurityRequiresSecureConnection)] = @"网络不给力"; // 1022
//        temp[@(NSURLErrorFileDoesNotExist)]                             = @"网络不给力"; // 请求的文件路径上文件不存在
//        temp[@(NSURLErrorFileIsDirectory)]                              = @"网络不给力"; // 请求的文件只是一个目录，而非文件
//        temp[@(NSURLErrorNoPermissionsToReadFile)]                      = @"网络不给力"; // 缺少权限无法读取文件
//        temp[@(NSURLErrorDataLengthExceedsMaximum)]                     = @"网络不给力"; // 资源数据大小超过最大限制
//        temp[@(NSURLErrorFileOutsideSafeArea)]                          = @"网络不给力"; // -1104
        messageInfo = [temp copy];
    }
    
    return messageInfo;
}


/**
 获取Bundle 文件

 @return 当前语言环境对应的翻译Bundle
 */
+ (NSBundle *)localizedStringBundle {
    // 获取翻译文件的Bundle
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // 获取Pod的Bundle
        NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
        NSString *bundlePath = [podBundle pathForResource:@"DLNetwork" ofType:@"bundle"];
        podBundle = [NSBundle bundleWithPath:bundlePath];
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[podBundle pathForResource:language ofType:@"lproj"]];
    }
    return bundle;
}

@end
