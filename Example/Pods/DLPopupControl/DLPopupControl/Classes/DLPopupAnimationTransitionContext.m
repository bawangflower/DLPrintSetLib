//
//  DLPopupAnimationTransitionContext.m
//  Pods
//
//  Created by yjj on 2017/6/12.
//
//

#import "DLPopupAnimationTransitionContext.h"

@implementation DLPopupAnimationTransitionContext

- (instancetype)initWithContainerView:(UIView *)containerView transitionType:(DLPopupControlTransitionType)transitionType {
    if (self = [super init]) {
        _containerView = containerView;
        _transitionType = transitionType;
    }
    return self;
}

@end
