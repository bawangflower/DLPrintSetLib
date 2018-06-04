//
//  DLNetworkErrorHandler.m
//  Pods
//
//  Created by yjj on 2017/5/24.
//
//

#import "DLNetworkErrorHandler.h"
#import <DLFoundationLib/DLViewUtility.h>
#import <DLFoundationLib/UIView+Responder.h>

@interface DLNetworkErrorHandler ()

/**
 错误提示的Alert是否正在显示
 */
@property (nonatomic, assign) BOOL alertIsShow;

@end

@implementation DLNetworkErrorHandler

+ (instancetype)defaultHandler {
    static DLNetworkErrorHandler *handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (void)dealNetworkError:(NSError *)error option:(DLNetworkErrorHandlerOptions)errorOption {
    
    NSString *message = error.userInfo[@"name"];
    
    // 不显示本次错误信息
    if (self.alertIsShow && errorOption == DLNetworkErrorHandlerOptionsMark) {
        return;
    }
    
    // 以Alert的方式展示错误信息
    if (errorOption == DLNetworkErrorHandlerOptionsMark || errorOption == DLNetworkErrorHandlerOptionsAlert) {
        self.alertIsShow = YES;
        __weak typeof(self) weakSelf = self;
        [DLViewUtility systemAlertWithMessage:message confirmCallBack:^(id object) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.alertIsShow = NO;
        }];
    }
    
    // 以Toast的方式展示错误信息
    if (errorOption == DLNetworkErrorHandlerOptionsToast) {
        [DLViewUtility toastWithMessage:message  delay:message.length < 5 ? 1.0 : (message.length < 15 ? 1.5 : 2.0)];
    }
}

@end
