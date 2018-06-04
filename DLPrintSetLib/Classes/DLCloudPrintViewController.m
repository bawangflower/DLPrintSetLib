//
//  DLCloudPrintTableVC.m
//  StaffAssistant
//
//  Created by LiYanQin on 2018/4/2.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import "DLCloudPrintViewController.h"
#import "DLMineSettingCell.h"
#import "DLCloudPrintCell.h"
#import "DLPrintModel.h"
#import "DLPrintSetApiManager.h"
#import "DLPrintSetConfig.h"
#import "DLPrintSetConstant.h"

@import DLFoundationLib;
@import Masonry;
@import Colours;
@import MJExtension;

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define KTitle @"title"
#define KKey @"key"
#define KCallBack @"callBack"
#define KSelected @"selected"
#define KModelCellIdentifier @"modelCellIdentifier"

#define CloudPrinterCodeTitle NSLocalizedString(@"云打印机器码", nil)
#define SelectPrinterTypeTitle NSLocalizedString(@"选择打印机类型", nil)
#define PleaseInputCloudPrinterCodeMessage NSLocalizedString(@"请填写云打印机器码", nil)
#define PleaseSelectPrinterTypeMessage NSLocalizedString(@"请选择打印机类型", nil)
#define PleaseInputPrintCountMessage NSLocalizedString(@"请填写打印份数", nil)

@interface DLCloudPrintViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *printerTypes;

@property (nonatomic, strong) NSDictionary *dictRelation;

@property (nonatomic, strong) NSMutableDictionary *pageData;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSNumber *printerTypeId;

@property (nonatomic, strong) NSMutableArray *mutCommonModels;

@property (nonatomic, strong) NSMutableArray *mutCustomModels;

@property (nonatomic, strong) DLPrintSetApiManager *manager;

@end

@implementation DLCloudPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor colorFromHexString:@"#eeeeee"];
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[DLMineSettingCell class] forCellReuseIdentifier:KDLMineSettingCellHaveCheckBoxReuseId];
    [self.tableView registerClass:[DLMineSettingCell class] forCellReuseIdentifier:kDLMineSettingCellDefaultReuseId];
    [self.tableView registerClass:[DLCloudPrintCell class] forCellReuseIdentifier:KModelCellIdentifier];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    UIButton *printTestButton = [[UIButton alloc] init];
    printTestButton.backgroundColor = [UIColor whiteColor];
    [printTestButton setTitle:KPrintTestTitle forState:UIControlStateNormal];
    [printTestButton setTitleColor:[UIColor colorFromHexString:@"#ff3b30"] forState:UIControlStateNormal];
    printTestButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:printTestButton];
    [printTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(ios 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else {
            make.bottom.equalTo(self.view);
        }
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    [printTestButton addTarget:self action:@selector(printTest:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupTableViewDataSource {
    NSNumber *lastTemplatetypeId = self.pageData[@"templateId"];
    NSArray *commons = self.dictRelation[@"templateCommonList"];
    _mutCommonModels = [[NSMutableArray alloc] init];
    for (NSDictionary *item in commons) {
        DLPrintModel *model = [DLPrintModel mj_objectWithKeyValues:item];
        model.selected = model.id.integerValue == lastTemplatetypeId.integerValue? @(1):@(0);
        model.templateComFlag = @(1);
        [_mutCommonModels addObject:model];
    }
    
    NSArray *customs = self.dictRelation[@"templateCustomList"];
    _mutCustomModels = [[NSMutableArray alloc] init];
    for (NSDictionary *item in customs) {
        DLPrintModel *model = [DLPrintModel mj_objectWithKeyValues:item];
        model.selected = model.id.integerValue == lastTemplatetypeId.integerValue? @(1):@(0);
        model.templateComFlag = @(0);
        [_mutCustomModels addObject:model];
    }
    
    NSArray *printerTypes = self.dictRelation[@"printerType"];
    NSNumber *lastPrinterTypeId = self.pageData[@"printerTypeId"];
    
    NSArray *relation = self.dictRelation[@"connectTypePrinterTypeRelation"];
    for (NSDictionary *item in relation) {
        NSNumber *connectTypeId = item[@"connectTypeId"];
        if (connectTypeId.integerValue == 3) {
            NSNumber *printerTypeId = item[@"printerTypeId"];
            for (NSDictionary *printerType in printerTypes) {
                NSMutableDictionary *mutItem = [[NSMutableDictionary alloc] initWithDictionary:printerType];
                NSNumber *idNumber = mutItem[@"id"];
                if (idNumber.integerValue == printerTypeId.integerValue) {
                    if (lastPrinterTypeId && idNumber.integerValue == lastPrinterTypeId.integerValue) {
                        [mutItem setObject:@(1) forKey:KSelected];
                    }else {
                        [mutItem setObject:@(0) forKey:KSelected];
                    }
                    [self.printerTypes addObject:mutItem];
                }
            }
        }
    }
    
    __weak typeof(self) weakSelf = self;
    //机器码
    CompletionBlock codeBlock = ^(NSIndexPath *indexPath) {
        [DLViewUtility systemInputAlertWithTitle:CloudPrinterCodeTitle
                                         message:nil placeholder:weakSelf.pageData[@"code"]
                                 confirmCallBack:^(NSString *object) {
                                     if (object && object.length > 0) {
                                         weakSelf.pageData[@"code"] = object;
                                         [weakSelf.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
                                     }else {
                                         [DLViewUtility toastWithMessage:NSLocalizedString(@"机器码不能为空", nil) delay:1.0];
                                     }
                                 }];
    };
    
    //打印份数
    CompletionBlock printCountBlcok = ^(NSIndexPath *indexPath) {
        DLAlertHandler handleer = ^(DLAlertItem *object) {
            // 如果不是自定义就将用户选择的数量缓存起来 然后刷新页面
            if (![object.title isEqualToString:kPrintSettingNumberDIY]) {
                weakSelf.pageData[@"printCount"] = @(object.title.integerValue);
                [weakSelf.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
            }else {
                [DLViewUtility systemInputAlertWithTitle:kPrintSettingNumberTitle message:nil configurationHandler:^(UITextField *textField) {
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                } confirmCallBack:^(NSString *number) {
                    if (!number || !number.length) {
                        [DLViewUtility toastWithMessage:NSLocalizedString(@"打印份数不能为空", nil) delay:1.0];
                    } else if (number.integerValue < 1 || number.integerValue > 100) {
                        [DLViewUtility toastWithMessage:NSLocalizedString(@"打印份数请设置 1~100", nil) delay:2.0];
                    } else {
                        weakSelf.pageData[@"printCount"] = @(number.integerValue);
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
            }
        };
        NSMutableArray *alertItems = [NSMutableArray array];
        for(int i = 1; i < 5; i ++) {
            [alertItems addObject:[DLAlertItem alertItemWithTitle:@(i).stringValue handler:handleer]];
        }
        [alertItems addObject:[DLAlertItem alertItemWithTitle:kPrintSettingNumberDIY handler:handleer]];
        [DLViewUtility systemSheetWithTitle:kPrintSettingNumberTitle items:alertItems];
    };
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:@[@{KTitle:CloudPrinterCodeTitle,KKey:@"code",KCallBack:codeBlock,kPrintSettingCellKey : kPrintSettingHostKey}]];
    [items addObject:@[@{KTitle:kPrintSettingNumberTitle,KKey:@"printCount" ,KCallBack:printCountBlcok,kPrintSettingCellKey: kPrintSettingNumberKey}]];
    _dataSource = [items copy];
    [self.tableView reloadData];
}

#pragma mark - public

- (void)reloadDataWithData:(NSDictionary *)pageData dictRelation:(NSDictionary *)dictRelation {
    _pageData = [[NSMutableDictionary alloc] initWithDictionary:pageData];
    _dictRelation = dictRelation;
    [self setupTableViewDataSource];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.printerTypes.count;
    }else if(section == 3){
        return 1;
    }else {
        NSArray *rows = self.dataSource[section - 1];
        return rows.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLMineSettingCell *cell;
    if (indexPath.section == 0) {
        //打印机类型
        cell = [tableView dequeueReusableCellWithIdentifier:KDLMineSettingCellHaveCheckBoxReuseId forIndexPath:indexPath];
        __block NSDictionary *item = self.printerTypes[indexPath.row];
        cell.textLabel.text = item[@"name"];
        NSNumber *isSelect = item[KSelected];
        [cell setCheckBoxIsSelect:isSelect.boolValue];
        WEAKSELF
        cell.checkBoxStatusHandler = ^(DLCheckBox *checkBox) {
            BOOL isSelect = checkBox.selected;
            STRONGSELF
            //选中打印机类型
            for (NSMutableDictionary *printer in strongSelf.printerTypes) {
                NSNumber *printerId = printer[@"id"];
                NSNumber *itemId = item[@"id"];
                if (printerId.integerValue == itemId.integerValue) {
                    printer[KSelected] = @(isSelect);
                }else {
                    printer[KSelected] = @(!isSelect);
                }
            }
            [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        };
    }else if(indexPath.section == 3) {
        //模板
        __weak DLCloudPrintCell *modelCell = [tableView dequeueReusableCellWithIdentifier:KModelCellIdentifier forIndexPath:indexPath];
        modelCell.commonModels = _mutCommonModels;
        modelCell.customModels = _mutCustomModels;
        NSNumber *templateComFlag = self.pageData[@"templateComFlag"];
        modelCell.modelType = templateComFlag.boolValue?DLModalTypeCommon:DLModalTypeCustom;
        
        WEAKSELF
        modelCell.changeModalTypeBlock = ^(DLModalType modalType) {
            STRONGSELF
            strongSelf.pageData[@"templateComFlag"] = modalType == DLModalTypeCommon ? @(1):@(0);
            [strongSelf.tableView reloadData];
        };
        modelCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return modelCell;
    }else {
        NSArray *sections = self.dataSource[indexPath.section - 1];
        NSDictionary *item = sections[indexPath.row];
        if ([item[kPrintSettingCellKey] isEqualToString:kPrintSettingHostKey]) {
            //机器码
            cell = [tableView dequeueReusableCellWithIdentifier:kDLMineSettingCellDefaultReuseId forIndexPath:indexPath];
            if(self.pageData.allKeys.count != 0) {
                cell.detailTextLabel.text = getNotNilValue(self.pageData[@"code"]);
            }
            
        }else if ([item[kPrintSettingCellKey] isEqualToString:kPrintSettingNumberKey]) {
            //打印份数
            cell = [tableView dequeueReusableCellWithIdentifier:kDLMineSettingCellDefaultReuseId forIndexPath:indexPath];
            if(self.pageData.allKeys.count != 0) {
                NSNumber *printCount = self.pageData[@"printCount"];
                cell.detailTextLabel.text = getNotNilValue(printCount.stringValue);
            }
        }
        
        cell.textLabel.text = item[KTitle];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UItableview delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return SelectPrinterTypeTitle;
    }else {
        return @" ";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = tableView.backgroundColor;
    [header.textLabel setFont:[UIFont systemFontOfSize:14]];
    header.textLabel.textColor = [UIColor colorFromHexString:@"#999999"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 32;
    }else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 3) {
        return;
    }else {
        NSArray *sections = self.dataSource[indexPath.section-1];
        NSDictionary *item = sections[indexPath.row];
        CompletionBlock callback = item[KCallBack];
        if (callback) {
            callback(indexPath);
        }
    }
}

#pragma mark - User Interaction

/**
 *  @author liyanqin
 *
 *  保存云打印设置
 *
 */
- (void)save {
    if ([self quickSaveAction]) {
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *jsonParam = [[NSMutableDictionary alloc] init];
    jsonParam[@"clientDeviceNo"] = [DLPrintSetConfig sharedConfig].clientDeviceNo;
    jsonParam[@"connectTypeId"] = @"3"; //云打印
    jsonParam[@"printerTypeId"] = self.printerTypeId;
    jsonParam[@"code"] = self.pageData[@"code"];
    jsonParam[@"printCount"] = self.pageData[@"printCount"];
    params[@"apiKey"] = @"ec-print-printer-save";
    NSNumber *templateComFlag = _pageData[@"templateComFlag"];
    jsonParam[@"templateComFlag"] = templateComFlag;
    NSMutableArray *models;
    if (templateComFlag.integerValue == 1) {
        models = _mutCustomModels;
    }else {
        models = _mutCustomModels;
    }
    for (DLPrintModel *model in models) {
        if (model.selected.boolValue) {
            jsonParam[@"templateId"] = model.id;
        }
    }
    params[@"jsonParam"] = jsonParam;
    params[@"sessionId"] = [DLPrintSetConfig sharedConfig].sessionId;
    [DLViewUtility show];
    [self.manager startRequestWithParams:params completionHandler:^(id responseObject) {
        [DLViewUtility showSuccessWithMessage:SaveSuccessMessage ];
        [self.navigationController popViewControllerAnimated:YES];
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
 *  打印测试
 *
 */
- (void)printTest:(UIButton *)button {
    if ([self quickSaveAction]) {
        return;
    }
    if ([DLPrintSetConfig sharedConfig].printTestBlock) {
        [DLPrintSetConfig sharedConfig].printTestBlock();
    }
}

#pragma mark - Internal Helpers

- (BOOL)quickSaveAction {
    for (NSMutableDictionary *printer in self.printerTypes) {
        NSNumber *isSelect = printer[KSelected];
        if (isSelect.boolValue) {
            self.printerTypeId = printer[@"id"];
        }
    }
    if (!self.printerTypeId) {
        [DLViewUtility toastWithMessage:PleaseSelectPrinterTypeMessage delay:1.0];
        return YES;
    }
    
    if (!self.pageData[@"code"]) {
        [DLViewUtility toastWithMessage:PleaseInputCloudPrinterCodeMessage delay:1.0];
        return YES;
    }
    
    if (!self.pageData[@"printCount"]) {
        [DLViewUtility toastWithMessage:PleaseInputPrintCountMessage delay:1.0];
        return YES;
    }
    return NO;
}

#pragma mark - Setters and Getters

- (NSMutableArray *)printerTypes {
    if (!_printerTypes) {
        _printerTypes = [[NSMutableArray alloc] init];
    }
    return _printerTypes;
}

- (DLPrintSetApiManager *)manager {
    if (!_manager) {
        _manager = [[DLPrintSetApiManager alloc] init];
    }
    return _manager;
}

@end
