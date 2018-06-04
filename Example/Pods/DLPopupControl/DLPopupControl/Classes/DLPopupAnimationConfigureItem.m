//
//  DLPopupAnimationConfigureItem.m
//  Pods
//
//  Created by yjj on 2017/6/8.
//
//

#import "DLPopupAnimationConfigureItem.h"

@implementation DLPopupAnimationConfigureItem

- (instancetype)init {
    if (self = [super init]) {
        self.presentDuration = 0.5;
        self.dismissDuration = 0.25;
        
        self.maskBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.enableAutoDismissWhenClickBackground = YES;
    }
    return self;
}

@end
