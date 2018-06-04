//
//  DLPrintSetApiManager.m
//  AFNetworking
//
//  Created by LiYanQin on 2018/6/4.
//

#import "DLPrintSetApiManager.h"
#import "DLPrintSetConfig.h"

@import DLFoundationLib;

@implementation DLPrintSetApiManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.config.requestProcessHandler = ^NSDictionary *(NSDictionary *requestParams, NSDictionary *httpBody) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:requestParams];
            params[@"clientTime"] = @((long)([[NSDate date] timeIntervalSince1970] * 1000));
            [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:NULL];
                    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    setupDictValue(params, key, jsonStr);
                }
            }];
            return params;
        };
        self.config.generalServer = [DLPrintSetConfig sharedConfig].generalServer;
        self.api = @"slh/api.do";
    }
    return self;
}

@end
