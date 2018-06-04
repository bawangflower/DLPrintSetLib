//
//  DLPrintSetConfig.m
//  AFNetworking
//
//  Created by LiYanQin on 2018/6/1.
//

#import "DLPrintSetConfig.h"

@implementation DLPrintSetConfig

+ (instancetype)sharedConfig {
    static DLPrintSetConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[DLPrintSetConfig alloc] init];
    });
    return config;
}

@end
