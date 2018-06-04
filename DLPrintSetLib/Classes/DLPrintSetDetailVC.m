//
//  DLPrintSetDetailVC.m
//  StaffAssistant
//
//  Created by LiYanQin on 2018/5/28.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import "DLPrintSetDetailVC.h"
#import "DLPrintProgramItem.h"
#import "DLPrintSegmentItem.h"
#import "DLPrintSetConfig.h"
#import "DLPrintSetApiManager.h"
#import "DLPrintSettingViewController.h"
#import "DLCloudPrintViewController.h"
#import <DLFoundationLib/DLViewUtility.h>

@import Masonry;
@import Colours;

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

@interface DLPrintSetDetailVC ()

@property (nonatomic, copy) NSArray <DLPrintSegmentItem *> *segments;

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) DLPrintSettingViewController *printVC;

@property (nonatomic, strong) DLCloudPrintViewController *cloudPrintVC;

@property (nonatomic, strong) DLPrintSetApiManager *manager;

@property (nonatomic, strong) NSDictionary *dictRelation;

@property (nonatomic, strong) NSDictionary *pageData;

@end

@implementation DLPrintSetDetailVC

- (instancetype)initWithTitle:(NSString *)title PrintSegments:(NSArray<DLPrintSegmentItem *> *)segments {
    if (self = [super init]) {
        _segments = segments;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self fetchDictRelation];
}

- (void)setupView {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (DLPrintSegmentItem *item in _segments) {
        if (item.printType == DLPrintTypeProgram) {
            [items addObject:@"打印程序"];
        }else if (item.printType == DLPrintTypeCloud) {
            [items addObject:@"云打印"];
        }
    }
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:[items copy]];
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.backgroundColor = [UIColor colorFromHexString:@"#f8f8f8"];
    _segmentControl.tintColor = [UIColor colorFromHexString:@"#29b6f6"];
    [self.view addSubview:_segmentControl];
    [_segmentControl addTarget:self action:@selector(changePrintType:) forControlEvents:UIControlEventValueChanged];
    [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self.view);
        make.top.equalTo(_segmentControl.mas_bottom);
    }];
    
    [self changePrintType:_segmentControl];
    
}

/**
 *  @author liyanqin
 *
 *  获取打印关联数据
 *
 */
- (void)fetchDictRelation {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"ec-print-printer-getDictRetation" forKey:@"apiKey"];
    [params setObject:[DLPrintSetConfig sharedConfig].sessionId forKey:@"sessionId"];
    WEAKSELF
    [DLViewUtility show];
    [self.manager startRequestWithParams:params completionHandler:^(id responseObject) {
        STRONGSELF
        NSDictionary *result = (NSDictionary *)responseObject;
        strongSelf.dictRelation = result[@"data"];
        [strongSelf fetchPageData];
    } failureHandler:^(NSError *error) {
        [DLViewUtility dismiss];
        if (error) {
            [DLViewUtility showErrorMessageWithAlert:error.userInfo[@"name"]];
        }
    }];
}

/**
 *  @author liyanqin
 *
 *  获取打印设置数据
 *
 */
- (void)fetchPageData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"ec-print-printer-getByClientDeviceNo" forKey:@"apiKey"];
    [params setObject:[DLPrintSetConfig sharedConfig].sessionId forKey:@"sessionId"];
    [params setObject:[DLPrintSetConfig sharedConfig].clientDeviceNo forKey:@"clientDeviceNo"];
    WEAKSELF
    [self.manager startRequestWithParams:params completionHandler:^(id responseObject) {
        [DLViewUtility dismiss];
        STRONGSELF
        NSNumber *code = responseObject[@"code"];
        if (code.integerValue == 0) {
            strongSelf.pageData = (NSDictionary *)responseObject[@"data"];
        }
        [strongSelf setupView];
        
    } failureHandler:^(NSError *error) {
        [DLViewUtility dismiss];
        if (error) {
            [DLViewUtility showErrorMessageWithAlert:error.userInfo[@"name"]];
        }
    }];
}

#pragma mark - User Interaction

- (void)save {
    DLPrintSegmentItem *item = _segments[_segmentControl.selectedSegmentIndex];
    if (item.printType == DLPrintTypeProgram) {
        [_printVC save];
    }else if (item.printType == DLPrintTypeCloud) {
        [_cloudPrintVC save];
    }
}

- (void)changePrintType:(UISegmentedControl *)segmentControl {
    NSInteger index = segmentControl.selectedSegmentIndex;
    DLPrintSegmentItem *item = _segments[index];
    if (item.printType == DLPrintTypeProgram) {
        if (_cloudPrintVC) {
            [_cloudPrintVC willMoveToParentViewController:nil];
            [_cloudPrintVC.view removeFromSuperview];
            [_cloudPrintVC removeFromParentViewController];
        }
        _printVC = [[DLPrintSettingViewController alloc] init];
        [self addChildViewController:self.printVC];
        [self.printVC reloadDataWithData:self.pageData dictRelation:self.dictRelation];
        self.printVC.printItem = item;
        [self.view addSubview:_printVC.view];
        [_printVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.mas_equalTo(41);
        }];
        [_printVC didMoveToParentViewController:self];
    }else if (item.printType == DLPrintTypeCloud) {
        if (_printVC) {
            [_printVC willMoveToParentViewController:nil];
            [_printVC.view removeFromSuperview];
            [_printVC removeFromParentViewController];
        }
        _cloudPrintVC = [[DLCloudPrintViewController alloc] init];
        [self addChildViewController:self.cloudPrintVC];
        [self.cloudPrintVC reloadDataWithData:self.pageData dictRelation:self.dictRelation];
        self.cloudPrintVC.printItem = item;
        [self.view addSubview:_cloudPrintVC.view];
        [_cloudPrintVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.mas_equalTo(41);
        }];
        [_cloudPrintVC didMoveToParentViewController:self];
    }
}

#pragma mark - Setters and Getters

- (DLPrintSetApiManager *)manager {
    if (!_manager) {
        _manager = [[DLPrintSetApiManager alloc] init];
    }
    return _manager;
}

@end
