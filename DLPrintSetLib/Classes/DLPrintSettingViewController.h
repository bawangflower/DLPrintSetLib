//
//  DLPrintSettingViewController.h
//  StaffAssistant
//
//  Created by yjj on 2017/4/29.
//  Copyright © 2017年 ecool. All rights reserved.
//  打印设置

#import <UIKit/UIKit.h>

@class DLPrintSegmentItem;

@interface DLPrintSettingViewController : UITableViewController

@property (nonatomic, strong) DLPrintSegmentItem *printItem;

- (void)reloadDataWithData:(NSDictionary *)pageData dictRelation:(NSDictionary *)dictRelation;

- (void)save;

@end
