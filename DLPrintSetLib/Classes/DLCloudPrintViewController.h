//
//  DLCloudPrintViewController.h
//  StaffAssistant
//
//  Created by LiYanQin on 2018/4/2.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLPrintSegmentItem.h"

@interface DLCloudPrintViewController : UIViewController

@property (nonatomic, strong) DLPrintSegmentItem *printItem;

- (void)reloadDataWithData:(NSDictionary *)pageData dictRelation:(NSDictionary *)dictRelation;

- (void)save;

@end
