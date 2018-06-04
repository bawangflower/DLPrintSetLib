//
//  DLPrintSetViewController.h
//  StaffAssistant
//
//  Created by LiYanQin on 2018/5/28.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLPrintChannelItem;

@interface DLPrintSetViewController : UIViewController

- (instancetype)initWithPrintChannels:(NSArray <DLPrintChannelItem *>*)printChannels;

@end
