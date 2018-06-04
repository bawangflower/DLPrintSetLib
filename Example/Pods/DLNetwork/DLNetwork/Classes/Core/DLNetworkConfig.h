//
//  DLNetworkConfig.h
//  PocketSLH
//
//  Created by GaoYuJian on 17/1/10.
//
//

#import <Foundation/Foundation.h>
#import "DLNetworkConstant.h"

@interface DLNetworkConfig : NSObject

/**
 业务服务器地址
 */
@property (nonatomic, copy) NSString *generalServer;

/**
 静态资源地址
 */
@property (nonatomic, copy) NSString *sourceServer;

/**
 DLNetworkManager useGeneralHeaders 为YES，会拼接generalHeaders
 */
@property (nonatomic, copy) NSDictionary *generalHeaders;

/**
 项目中网络请求公共参数，DLNetworkManager useGeneralParams为YES, 会拼接generalParams
 */
@property (nonatomic, copy) NSDictionary *generalParams;

/**
 对请求的参数做额外的处理
 */
@property (nonatomic, copy) DLNetworkRequestProcessBlock requestProcessHandler;

/**
 对返回数据做额外处理
 */
@property (nonatomic, copy) DLNetworkResponseProcessBlock responseProcessHandler;

/**
 是否打印请求URL和参数,默认为YES
 */
@property (nonatomic, assign) BOOL consoleRequestLog;

/**
 是否打印返回内容,默认为NO
 */
@property (nonatomic, assign) BOOL consoleResponseLog;

/**
 是否翻译系统网络错误信息的文案
 */
@property (nonatomic, assign) BOOL translateUrlErrorDesc;

+ (instancetype)sharedConfig;

- (void)setGeneralParam:(NSString *)value key:(NSString *)key;

@end
