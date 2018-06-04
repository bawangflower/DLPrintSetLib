//
//  DLPrintSetViewController.m
//  StaffAssistant
//
//  Created by LiYanQin on 2018/5/28.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import "DLPrintSetViewController.h"
#import "DLPrintChannelItem.h"
#import "DLPrintSetDetailVC.h"
#import "DLPrintSegmentItem.h"
#import "DLPrintSetConfig.h"
#import <Masonry/Masonry.h>
#import <Colours/Colours.h>
#import <DLFoundationLib/DLAlertItem.h>
#import <DLFoundationLib/DLViewUtility.h>
#import "DLPrintSetUtility.h"

static NSString *const KCellIdentifier = @"CellIdentifier";

#define PrintTypeTitle NSLocalizedString(@"打印模式", nil)
#define kCanotSetRemoteModel NSLocalizedString(@"不能设置远程打印", nil)
#define kPrintAutoPrintSettingTitle NSLocalizedString(@"开单后自动打印", nil)

@interface DLPrintSetViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) NSArray <DLPrintChannelItem *>* channels;

@property (nonatomic, strong) NSArray *printModelItems;

@end

@implementation DLPrintSetViewController

- (instancetype)initWithPrintChannels:(NSArray<DLPrintChannelItem *> *)printChannels {
    if (self = [super init]) {
        _channels = printChannels;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打印设置";
    self.view.backgroundColor = [UIColor colorFromHexString:@"#eeeeee"];

    UIView *printTypeView = [[UIView alloc] init];
    printTypeView.backgroundColor = [UIColor colorFromHexString:@"#f8f8f8"];
    [self.view addSubview:printTypeView];
    [printTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available (iOS 11.0,*)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }else {
            make.top.equalTo(self.mas_topLayoutGuide);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePrintMode)];
    [printTypeView addGestureRecognizer:tap];
    printTypeView.userInteractionEnabled = YES;
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.userInteractionEnabled = YES;
    titleL.textColor = [UIColor colorFromHexString:@"#999999"];
    titleL.font = [UIFont systemFontOfSize:14];
    titleL.text = PrintTypeTitle;
    [printTypeView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.equalTo(printTypeView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[DLPrintSetUtility dl_bundleImageWithName:@"arrow-down"]];
    imageView.userInteractionEnabled = YES;
    [printTypeView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.equalTo(printTypeView);
    }];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.userInteractionEnabled = YES;
    _detailLabel.textColor = [UIColor colorFromHexString:@"#3d4245"];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    [printTypeView addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(printTypeView);
        make.right.equalTo(imageView.mas_left).offset(-13);
    }];
    
    _detailLabel.text = self.printModelItems[[DLPrintSetConfig sharedConfig].modelType][@"value"];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor colorFromHexString:@"#eeeeee"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KCellIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(printTypeView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
    }];
    
    UIView *autoPrintView = [[UIView alloc] init];
    autoPrintView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:autoPrintView];
    [autoPrintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.tableView.mas_bottom);
        if (@available (iOS 11.0,*)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else {
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
    }];
    
    UILabel *autoLabel = [[UILabel alloc] init];
    autoLabel.text = kPrintAutoPrintSettingTitle;
    autoLabel.textColor = [UIColor colorFromHexString:@"#3d4245"];
    autoLabel.font = [UIFont systemFontOfSize:14];
    [autoPrintView addSubview:autoLabel];
    [autoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.equalTo(autoPrintView);
    }];
    
    UISwitch *autoPrintSwitch = [[UISwitch alloc] init];
    [autoPrintSwitch setOn:[DLPrintSetConfig sharedConfig].openAutoPrint];
    [autoPrintSwitch addTarget:self action:@selector(openAutoPrint:) forControlEvents:UIControlEventValueChanged];
    [autoPrintView addSubview:autoPrintSwitch];
    [autoPrintSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(autoPrintView);
    }];
}

#pragma mark - User interaction

- (void)openAutoPrint:(UISwitch *)autoSwitch {
    if ([DLPrintSetConfig sharedConfig].openAutoPrintBlock) {
        [DLPrintSetConfig sharedConfig].openAutoPrintBlock(autoSwitch.on);
    }
}

- (void)changePrintMode {
    DLAlertHandler handler = ^(DLAlertItem *object) {
        // 获取用户选择的打印model的索引
        __block NSUInteger selectedIdex = 0;
        [self.printModelItems enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([object.title isEqualToString:obj[@"value"]]) {
                selectedIdex = idx;
            }
        }];
        
        // 当服务端没有开启远程打印的时候 本地不能设置远程打印
        if ([[DLPrintSetConfig sharedConfig].salesPrintRemote isEqualToString:@"0"] && selectedIdex > 0) {
            [DLViewUtility toastWithMessage:kCanotSetRemoteModel delay:1.0];
        }else {
            // 设置用户选择的模式
            if ([DLPrintSetConfig sharedConfig].changePrintModeBlock) {
                [DLPrintSetConfig sharedConfig].changePrintModeBlock(selectedIdex);
            }
            _detailLabel.text = self.printModelItems[[DLPrintSetConfig sharedConfig].modelType][@"value"];
        }
    };
    
    NSMutableArray *alertItems = [NSMutableArray array];
    for (NSDictionary *item in self.printModelItems) {
        [alertItems addObject:[DLAlertItem alertItemWithTitle:item[@"value"] handler:handler]];
    }
    [DLViewUtility systemSheetWithTitle:PrintTypeTitle items:alertItems];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _channels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCellIdentifier forIndexPath:indexPath];
    DLPrintChannelItem *item = _channels[indexPath.row];
    cell.textLabel.text = item.title;
    cell.imageView.image = [DLPrintSetUtility dl_bundleImageWithName:item.icon];
    return cell;
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLPrintChannelItem *item = _channels[indexPath.row];
    NSArray <DLPrintSegmentItem *>*segmentItems = item.connectTypes;
    DLPrintSetDetailVC *printSetDetailVC = [[DLPrintSetDetailVC alloc] initWithTitle:item.title PrintSegments:segmentItems];
    [self.navigationController pushViewController:printSetDetailVC animated:YES];
}

#pragma mark - Setters and Getters

- (NSArray *)printModelItems {
    if (!_printModelItems) {
        _printModelItems = @[ @{ @"key" : @0, @"value": NSLocalizedString(@"本地打印", nil) },
                              @{ @"key" : @1, @"value": NSLocalizedString(@"远程打印", nil) },
                              @{ @"key" : @2, @"value": NSLocalizedString(@"本地+远程打印", nil) } ];
    }
    return _printModelItems;
}

@end
