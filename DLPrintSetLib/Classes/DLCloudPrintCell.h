//
//  DLCloudPrintCell.h
//  StaffAssistant
//
//  Created by LiYanQin on 2018/4/4.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,DLModalType) {
    DLModalTypeCommon = 1,
    DLModalTypeCustom = 2
};

typedef void (^ChangeModalTypeBlock)(DLModalType modalType);

@interface DLCloudPrintCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *commonModels;
@property (nonatomic, strong) NSMutableArray *customModels;

@property (nonatomic, assign) DLModalType modelType;

@property (nonatomic, copy) ChangeModalTypeBlock changeModalTypeBlock;

@end
