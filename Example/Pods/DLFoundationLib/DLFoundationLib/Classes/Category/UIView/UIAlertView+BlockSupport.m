//
//  UIAlertView+BlockSupport.m
//  slh_new
//
//  Created by GaoYuJian on 16/10/19.
//  Copyright © 2016年 dlsoft. All rights reserved.
//

#import "UIAlertView+BlockSupport.h"
#import <objc/runtime.h>

@implementation UIAlertView (BlockSupport)

- (void)setAlertBlock:(DLAlertViewBlock)alertBlock {
    objc_setAssociatedObject(self, @selector(alertBlock), alertBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DLAlertViewBlock)alertBlock {
    return objc_getAssociatedObject(self, _cmd);
}

@end
