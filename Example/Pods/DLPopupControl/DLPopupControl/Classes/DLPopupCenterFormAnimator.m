//
//  DLPopupCenterFormAnimator.m
//  Pods
//
//  Created by yjj on 2017/6/14.
//
//

#import "DLPopupCenterFormAnimator.h"

@implementation DLPopupCenterFormAnimator

- (NSTimeInterval)transitionDuration:(DLPopupAnimationTransitionContext *)context {
    if (context.transitionType == DLPopupControlTransitionPresent) {
        return context.configItem.presentDuration;
    }
    return context.configItem.presentDuration;
}

- (void)popupControllerAnimateWithContext:(DLPopupAnimationTransitionContext *)context compelete:(void (^)(void))compelete {
    UIView *containerView = context.containerView;
    if (context.transitionType == DLPopupControlTransitionPresent) {
        containerView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView animateWithDuration:[self transitionDuration:context] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            compelete();
        }];
    }else {
        compelete();
    }
}

@end
