//
//  DLNetworkConfig.m
//  PocketSLH
//
//  Created by GaoYuJian on 17/1/10.
//
//

#import "DLNetworkConfig.h"

@implementation DLNetworkConfig

+ (instancetype)sharedConfig {
    static DLNetworkConfig *networkConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkConfig = [[DLNetworkConfig alloc] init];
        networkConfig.consoleRequestLog     = YES;
        networkConfig.consoleResponseLog    = NO;
        networkConfig.translateUrlErrorDesc = NO;
    });
    return networkConfig;
}

- (void)setGeneralParam:(NSString *)value key:(NSString *)key {
    if (value.length && key.length) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:self.generalParams];
        params[key] = value;
        self.generalParams = params;
    }
}

@end
