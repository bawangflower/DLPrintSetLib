//
//  DLAlertViewConfig.m
//  Pods
//
//  Created by GaoYuJian on 2017/4/21.
//
//

#import "DLAlertViewConfig.h"
#import "NSBundle+DLFoundationLib.h"
@import Colours;

@implementation DLAlertViewConfig

@synthesize defaultTextOK = _defaultTextOK;
@synthesize defaultTextCancel = _defaultTextCancel;
@synthesize tintColor = _tintColor;

+ (instancetype)sharedConfig {
    static DLAlertViewConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[DLAlertViewConfig alloc] init];
    });
    return config;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaultTextOK = [NSBundle dl_localizedStringForKey:@"确 定" value:nil];
        self.defaultTextCancel = [NSBundle dl_localizedStringForKey:@"取 消" value:nil];
        self.tintColor = [UIColor colorFromHexString:@"#4990E2"];
    }
    return self;
}

@end
