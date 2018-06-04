//
//  DLPrintSetDetailVC.h
//  StaffAssistant
//
//  Created by LiYanQin on 2018/5/28.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLPrintSegmentItem;

@interface DLPrintSetDetailVC : UIViewController

- (instancetype)initWithTitle:(NSString *)title PrintSegments:(NSArray <DLPrintSegmentItem *> *)segments;

@end
