//
//  DLPrintModelWebVC.m
//  StaffAssistant
//
//  Created by LiYanQin on 2018/4/8.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import "DLPrintModelWebVC.h"
#import "DLPrintModel.h"
#import "DLPrintSetConfig.h"
#import <DLNetwork/DLNetworkConfig.h>

@import Masonry;

@interface DLPrintModelWebVC ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) DLPrintModel *model;

@end

@implementation DLPrintModelWebVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    //上一句话是防止手动先把设备置为竖屏,导致下面的语句失效.
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
}

- (instancetype)initWithModel:(DLPrintModel *)model {
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"编辑模板", nil);
    
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSString *urlStr = [NSString stringWithFormat:@"%@/slh/ipad/printer/index.html?sessionid=%@&templateId=%@&isCommon=%@",[DLNetworkConfig sharedConfig].generalServer,[DLPrintSetConfig sharedConfig].sessionId,_model.templateTypeId.stringValue,_model.templateComFlag.stringValue];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}


@end
