//
//  DLPrintSettingViewController.m
//  StaffAssistant
//
//  Created by yjj on 2017/4/29.
//  Copyright © 2017年 ecool. All rights reserved.
//

#import "DLPrintSettingViewController.h"
#import "DLPrintSegmentItem.h"
#import "DLPrintProgramItem.h"
#import "DLPrintSetConfig.h"
#import "DLMineSettingCell.h"
#import "DLPrintSetApiManager.h"
#import "DLPrintSetConstant.h"

@import DLFoundationLib;
@import Colours;

#define kPrintSettingHostTitle      NSLocalizedString(@"打印机地址配置", nil)
#define kPrintSettingPortTitle      NSLocalizedString(@"打印机端口配置", nil)

#define kCellHeaderReuseId  @"kCellHeaderReuseId"

@interface DLPrintSettingViewController ()

@property (nonatomic, strong) DLPrintProgramItem *printProgramItem;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSDictionary *dictRelation;

@property (nonatomic, strong) NSDictionary *pageData;

@property (nonatomic, strong) DLPrintSetApiManager *manager;

@end

@implementation DLPrintSettingViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"打印设置", nil);
    self.printProgramItem.printProgramIP = [DLPrintSetConfig sharedConfig].programItem.printProgramIP;
    self.printProgramItem.printProgramPort = [DLPrintSetConfig sharedConfig].programItem.printProgramPort;
    self.printProgramItem.printProgramCount = [DLPrintSetConfig sharedConfig].programItem.printProgramCount;
    
    [self setupSubViews];
}

- (void)setupSubViews {
    [self.tableView registerClass:[DLMineSettingCell class] forCellReuseIdentifier:kDLMineSettingCellDefaultReuseId];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kCellHeaderReuseId];
    [self.tableView setBackgroundColor:[UIColor colorFromHexString:@"#EFEFF4"]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

#pragma mark - public

- (void)reloadDataWithData:(NSDictionary *)pageData dictRelation:(NSDictionary *)dictRelation {
    _pageData = pageData;
    _dictRelation = dictRelation;
    if (_pageData) {
        [self.tableView reloadData];
    }
}

- (void)save {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *jsonParam = [[NSMutableDictionary alloc] init];
    jsonParam[@"clientDeviceNo"] = [DLPrintSetConfig sharedConfig].clientDeviceNo;
    jsonParam[@"connectTypeId"] = @"2";//打印程序
    jsonParam[@"printerTypeId"] = @"100";//pc
    if (_printItem.printChannelId == DLPrintChannelIdLocal) {
        jsonParam[@"printChannelId"] = @"1";
    }else if (_printItem.printChannelId == DLPrintChannelIdBarcode) {
        jsonParam[@"printChannelId"] = @"3";
    }else if (_printItem.printChannelId == DLPrintChannelIdDoc) {
        jsonParam[@"printChannelId"] = @"4";
    }
    NSMutableDictionary *paramInfo = [[NSMutableDictionary alloc] init];
    [paramInfo setValue:self.printProgramItem.printProgramIP forKey:@"serverIp"];
    [paramInfo setValue:self.printProgramItem.printProgramPort forKey:@"serverPort"];
    jsonParam[@"params"] = [paramInfo copy];
    
    jsonParam[@"printCount"] = self.pageData[@"printCount"];
    params[@"apiKey"] = @"ec-print-printer-save";
    params[@"jsonParam"] = jsonParam;
    params[@"sessionId"] = [DLPrintSetConfig sharedConfig].sessionId;
    [DLViewUtility show];
    __weak typeof(self) weakSelf = self;
    [self.manager startRequestWithParams:params completionHandler:^(id responseObject) {
        [DLViewUtility showSuccessWithMessage:SaveSuccessMessage ];
        
        if ([DLPrintSetConfig sharedConfig].savePrintProgramInfoBlock) {
            [DLPrintSetConfig sharedConfig].savePrintProgramInfoBlock([DLPrintSetConfig sharedConfig].programItem);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failureHandler:^(NSError *error) {
        [DLViewUtility dismiss];
        if (error) {
            [DLViewUtility showErrorMessageWithAlert:error.userInfo[@"name"]];
        }
    }];
}

#pragma mark - UITablViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLMineSettingCell *cell;
    NSDictionary *item = self.dataSource[indexPath.section][indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:kDLMineSettingCellDefaultReuseId];
    NSString *params = _pageData[@"params"];
    if (params.length>0) {
        //服务端保存过数据
        NSDictionary *paramsDic = [self dictWithJsonString:params];
        cell.detailTextLabel.text = getNotNilValue(paramsDic[item[KRemoteDataKey]]);
    }else {
        //本地数据
        if ([item[kPrintSettingCellKey] isEqualToString:kPrintSettingHostKey]) {
            cell.detailTextLabel.text = self.printProgramItem.printProgramIP;
        }else if ([item[kPrintSettingCellKey] isEqualToString:kPrintSettingPortKey]) {
            cell.detailTextLabel.text = self.printProgramItem.printProgramPort;
        }else if ([item[kPrintSettingCellKey] isEqualToString:kPrintSettingNumberKey]) {
            cell.detailTextLabel.text = self.printProgramItem.printProgramCount;
        }
    }
    cell.textLabel.text = item[kPrintSettingCellTitle];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = self.dataSource[indexPath.section][indexPath.row];
    
    __weak typeof(self) weekSelf = self;
    if ([item[kPrintSettingCellKey] isEqualToString:kPrintSettingNumberKey]) { // 设置打印份数
        DLAlertHandler handleer = ^(DLAlertItem *object) {
            // 如果不是自定义就将用户选择的数量缓存起来 然后刷新页面
            if (![object.title isEqualToString:kPrintSettingNumberDIY]) {
                weekSelf.printProgramItem.printProgramCount = object.title;
                [weekSelf.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
            }else {
                [DLViewUtility systemInputAlertWithTitle:item[kPrintSettingCellTitle] message:nil configurationHandler:^(UITextField *textField) {
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                } confirmCallBack:^(NSString *number) {
                    if (!number || !number.length) {
                        [DLViewUtility toastWithMessage:NSLocalizedString(@"打印份数不能为空", nil) delay:1.0];
                    } else if (number.integerValue < 1 || number.integerValue > 100) {
                        [DLViewUtility toastWithMessage:NSLocalizedString(@"打印份数请设置 1~100", nil) delay:2.0];
                    } else {
                        weekSelf.printProgramItem.printProgramCount = number;
                        [weekSelf.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
            }
        };
        NSMutableArray *alertItems = [NSMutableArray array];
        for(int i = 1; i < 5; i ++) {
            [alertItems addObject:[DLAlertItem alertItemWithTitle:@(i).stringValue handler:handleer]];
        }
        [alertItems addObject:[DLAlertItem alertItemWithTitle:kPrintSettingNumberDIY handler:handleer]];
        [DLViewUtility systemSheetWithTitle:item[kPrintSettingCellTitle] items:alertItems];
        
    }else if ([item[kPrintSettingCellKey] isEqualToString:kPrintSettingHostKey]) { //设置IP地址
        [DLViewUtility systemInputAlertWithTitle:item[kPrintSettingCellTitle]
                                         message:nil placeholder:weekSelf.printProgramItem.printProgramIP
                                 confirmCallBack:^(NSString *object) {
                                     if (![weekSelf checkHost:object]) {
                                         [DLViewUtility toastWithMessage:NSLocalizedString(@"打印机地址格式不正确", nil) delay:1.0];
                                     }else {
                                         weekSelf.printProgramItem.printProgramIP = object;
                                         [weekSelf.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
                                     }
                                 }];
        
    } else { // 设置打印机端口号
        [DLViewUtility systemInputAlertWithTitle:item[kPrintSettingCellTitle] message:nil configurationHandler:^(UITextField *textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        } confirmCallBack:^(NSString *number) {
            if (!number || !number.length) {
                [DLViewUtility toastWithMessage:NSLocalizedString(@"打印端口号不能为空", nil) delay:1.0];
            }else {
                weekSelf.printProgramItem.printProgramPort = number;
                [weekSelf.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCellHeaderReuseId];
    header.backgroundView = [[UIImageView alloc] initWithImage:[UIImage dl_imageWithColor:self.view.backgroundColor]];
    return header;
}

#pragma mark - Help 
//((?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d))))
- (BOOL)checkHost:(NSString *)host {
    if (!host.length) {
        return NO;
    }
    NSString *pattern = @"((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))";
    NSRange range = [host rangeOfString:pattern options:NSRegularExpressionSearch];
    return (range.location != NSNotFound && range.length > 0);
}

- (NSDictionary *)dictWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - Getter

- (NSArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObject:@[
                          @{ kPrintSettingCellTitle : kPrintSettingHostTitle, kPrintSettingCellKey : kPrintSettingHostKey ,KRemoteDataKey:@"serverIp" },
                          @{ kPrintSettingCellTitle : kPrintSettingPortTitle, kPrintSettingCellKey : kPrintSettingPortKey ,KRemoteDataKey:@"serverPort" },
                          
                          ]];
        [temp addObject:@[ @{ kPrintSettingCellTitle : kPrintSettingNumberTitle, kPrintSettingCellKey : kPrintSettingNumberKey ,KRemoteDataKey:@"printCount"}]];
        _dataSource = temp.copy;
    }
    return _dataSource;
}

- (DLPrintSetApiManager *)manager {
    if (!_manager) {
        _manager = [[DLPrintSetApiManager alloc] init];
    }
    return _manager;
}

- (DLPrintProgramItem *)printProgramItem {
    if (!_printProgramItem) {
        _printProgramItem = [[DLPrintProgramItem alloc] init];
    }
    return _printProgramItem;
}

@end
