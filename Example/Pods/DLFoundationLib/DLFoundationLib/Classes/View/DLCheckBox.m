//
//  DLCheckBox.m
//  PocketSLH
//
//  Created by yunyu on 16/3/3.
//
//

#import "DLCheckBox.h"
#import "NSBundle+DLFoundationLib.h"

@implementation DLCheckBox

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isAutoChangeStatus  = YES;
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setImage:[UIImage imageNamed:@"checkbox_action_normal" inBundle:[NSBundle dl_fundationLibImageBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"checkbox_action_selected" inBundle:[NSBundle dl_fundationLibImageBundle] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
}

- (void)changeSelectedStatus {
    self.selected = !self.selected;
}

- (void)setIsAutoChangeStatus:(BOOL)isAutoChangeStatus {
    _isAutoChangeStatus = isAutoChangeStatus;
    if (isAutoChangeStatus == YES) {
       [self addTarget:self action:@selector(changeSelectedStatus) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self removeTarget:self action:@selector(changeSelectedStatus) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
