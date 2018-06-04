//
//  DLMineSettingCell.h
//  StaffAssistant
//
//  Created by yjj on 2017/4/19.
//  Copyright © 2017年 ecool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DLFoundationLib/DLBlockType.h>

#define kDLMineSettingCellDefaultReuseId   @"kDLMineSettingCellDefaultReuseId"
#define kDLMineSettingCellHaveImageReuseId @"kDLMineSettingCellHaveImageReuseId"
#define KDLMineSettingCellHaveCheckBoxReuseId @"KDLMineSettingCellHaveCheckBoxReuseId"

@interface DLMineSettingCell : UITableViewCell

/**
 是否打开开关
 */
@property (nonatomic, assign) BOOL switchIsOpen;

@property (nonatomic, assign) BOOL checkBoxIsSelect;


/**
 监听Switch状态的变化
 */
@property (nonatomic, copy) CompletionBlock switchStatusHandler;

@property (nonatomic, copy) CompletionBlock checkBoxStatusHandler;

@property (nonatomic, assign) BOOL showUnreadMessageIndicator;

@end
