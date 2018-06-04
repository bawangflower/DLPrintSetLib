//
//  DLPrintSetApiManager.m
//  AFNetworking
//
//  Created by LiYanQin on 2018/6/4.
//

#import "DLPrintSetApiManager.h"
#import "DLPrintSetConfig.h"

@implementation DLPrintSetApiManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"dlUseFieldNameAlias"] = @"1";
        self.generalParams = param;
        self.url = [DLPrintSetConfig sharedConfig].serverUrl;
        self.api = @"slh/api.do";
    }
    return self;
}

@end
