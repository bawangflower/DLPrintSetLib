//
//  DLPopupHorizontalAnimator.m
//  Pods
//
//  Created by yjj on 2017/6/13.
//
//

#import "DLPopupHorizontalAnimator.h"

@implementation DLPopupHorizontalAnimator

- (NSTimeInterval)transitionDuration:(DLPopupAnimationTransitionContext *)context {
    if (context.transitionType == DLPopupControlTransitionPresent) {
        return context.configItem.presentDuration;
    }
    return context.configItem.dismissDuration;
}

- (void)popupControllerAnimateWithContext:(DLPopupAnimationTransitionContext *)context compelete:(void (^)(void))compelete {
    UIView *containerView = context.containerView;
    CGAffineTransform transform;
    if (context.configItem.popupType == DLPopupTypeRightSheet) {
        transform = CGAffineTransformMakeTranslation(containerView.frame.size.width, 0);
    }else {
        transform = CGAffineTransformMakeTranslation(- containerView.bounds.size.width, 0);
    }
    
    if (context.transitionType == DLPopupControlTransitionPresent) {
        containerView.transform = transform;
        [UIView animateWithDuration:[self transitionDuration:context] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            context.containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            compelete();
        }];
    }else {
        [UIView animateWithDuration:[self transitionDuration:context] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            containerView.transform = transform;
        } completion:^(BOOL finished) {
            context.containerView.transform = CGAffineTransformIdentity;
            compelete();
        }];
    }
}

@end
