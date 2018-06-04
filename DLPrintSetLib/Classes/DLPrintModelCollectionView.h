//
//  DLPrintModelCollectionView.h
//  StaffAssistant
//
//  Created by LiYanQin on 2018/4/8.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLPrintModel;

typedef void (^DLPrintModelCollectionViewBlock)(DLPrintModel *model);

@interface DLPrintModelCollectionView : UICollectionView

@property (nonatomic, strong) NSArray <DLPrintModel *>* models;

@property (nonatomic, copy) DLPrintModelCollectionViewBlock selectModelBlock;

@end
