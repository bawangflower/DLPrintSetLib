//
//  DLViewController.m
//  DLPrintSetLib
//
//  Created by bawangflower on 06/01/2018.
//  Copyright (c) 2018 bawangflower. All rights reserved.
//

#import "DLViewController.h"
#import <DLPrintSetLib/DLPrintSetLib.h>
#import <Masonry/Masonry.h>

#define BillLocalTitle NSLocalizedString(@"单据本地", nil)
#define BillRemoteTitle NSLocalizedString(@"单据远程", nil)
#define BarcodePrintTitle NSLocalizedString(@"条码打印", nil)
#define DocPrintTitle NSLocalizedString(@"物流面单", nil)

@interface DLViewController ()

@end

@implementation DLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"打印设置";
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"打印设置" forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 1;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(100);
    }];
    [button addTarget:self action:@selector(jumpToPrintSet) forControlEvents:UIControlEventTouchUpInside];
}

- (void)jumpToPrintSet {
    DLPrintSegmentItem *item1 = [[DLPrintSegmentItem alloc] init];
    item1.printType = DLPrintTypeProgram;
    item1.printChannelId = DLPrintChannelIdLocal;
    DLPrintSegmentItem *item2 = [[DLPrintSegmentItem alloc] init];
    item2.printType = DLPrintTypeCloud;
    item2.printChannelId = DLPrintChannelIdLocal;
    DLPrintChannelItem *channelItem1 = [[DLPrintChannelItem alloc] init];
    channelItem1.icon = @"billLocal";
    channelItem1.title = BillLocalTitle;
    channelItem1.connectTypes = @[item1,item2];
    
    DLPrintSegmentItem *item0 = [[DLPrintSegmentItem alloc] init];
    item0.printType = DLPrintTypeCloud;
    item0.printChannelId = DLPrintChannelIdRemote;
    DLPrintChannelItem *channelItem2 = [[DLPrintChannelItem alloc] init];
    channelItem2.icon = @"billRemote";
    channelItem2.title = BillRemoteTitle;
    channelItem2.connectTypes = @[item0];
    
    DLPrintSegmentItem *item3 = [[DLPrintSegmentItem alloc] init];
    item3.printType = DLPrintTypeProgram;
    item3.printChannelId = DLPrintChannelIdBarcode;
    DLPrintChannelItem *channelItem3 = [[DLPrintChannelItem alloc] init];
    channelItem3.icon = @"barcodePrint";
    channelItem3.title = BarcodePrintTitle;
    channelItem3.connectTypes = @[item3];
    
    DLPrintSegmentItem *item4 = [[DLPrintSegmentItem alloc] init];
    item4.printType = DLPrintTypeProgram;
    item4.printChannelId = DLPrintChannelIdDoc;
    DLPrintChannelItem *channelItem4 = [[DLPrintChannelItem alloc] init];
    channelItem4.icon = @"docPrint";
    channelItem4.title = DocPrintTitle;
    channelItem4.connectTypes = @[item4];
    
    DLPrintSetConfig *config = [DLPrintSetConfig sharedConfig];
    config.openAutoPrint = YES;
    config.salesPrintRemote = @"0";
    config.modelType = DLPrintModelLocal;
    config.sessionId = @"5782A38B-8A34-3F89-ECBB-4F71406C36F6";
    config.generalServer = @"http://139.196.124.16:7901";
    config.clientDeviceNo = @"18868378766";
    DLPrintProgramItem *printProgramItem = [[DLPrintProgramItem alloc] init];
    printProgramItem.printProgramIP = @"192.168.8.888";
    printProgramItem.printProgramPort = @"88888";
    printProgramItem.printProgramCount = @"2";
    config.programItem = printProgramItem;
    
    
    DLPrintSetViewController *printSetVC = [[DLPrintSetViewController alloc] initWithPrintChannels:@[channelItem1,channelItem2,channelItem3,channelItem4]];
    [self.navigationController pushViewController:printSetVC animated:YES];
}


@end
