//
//  UIAlertView+BlockSupport.h
//  slh_new
//
//  Created by GaoYuJian on 16/10/19.
//  Copyright © 2016年 dlsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DLAlertViewBlock)(NSUInteger index);

@interface UIAlertView (BlockSupport)

@property (nonatomic, copy) DLAlertViewBlock alertBlock;

@end
