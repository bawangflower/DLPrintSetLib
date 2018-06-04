//
//  DLPrintModelCell.h
//  StaffAssistant
//
//  Created by LiYanQin on 2018/4/4.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLPrintModel.h"

typedef void(^DLPrintModelCellBlock)(DLPrintModel *model);

@interface DLPrintModelCell : UICollectionViewCell

@property (nonatomic, strong) DLPrintModel *model;

@property (nonatomic, copy) DLPrintModelCellBlock selectModelBlock;

@end
