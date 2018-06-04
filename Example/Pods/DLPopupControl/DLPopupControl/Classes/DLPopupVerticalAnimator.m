//
//  DLPopupVerticalAnimator.m
//  Pods
//
//  Created by yjj on 2017/6/14.
//
//

#import "DLPopupVerticalAnimator.h"

@implementation DLPopupVerticalAnimator

- (NSTimeInterval)transitionDuration:(DLPopupAnimationTransitionContext *)context {
    if (context.transitionType == DLPopupControlTransitionPresent) {
        return context.configItem.presentDuration;
    }
    return context.configItem.dismissDuration;
}

- (void)popupControllerAnimateWithContext:(DLPopupAnimationTransitionContext *)context compelete:(void (^)(void))compelete {
    UIView *containerView = context.containerView;
    CGAffineTransform transform;
    if (context.configItem.popupType == DLPopupTypeTopSheet) {
        transform = CGAffineTransformMakeTranslation(0, - containerView.bounds.size.height);
    }else {
        transform = CGAffineTransformMakeTranslation(0, containerView.superview.bounds.size.height - containerView.frame.origin.y);
    }
    if (context.transitionType == DLPopupControlTransitionPresent) {
        containerView.transform = transform;
        [UIView animateWithDuration:[self transitionDuration:context] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            compelete();
        }];
    }else {
        [UIView animateWithDuration:[self transitionDuration:context] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            containerView.transform = transform;
        } completion:^(BOOL finished) {
            containerView.transform = CGAffineTransformIdentity;
            compelete();
        }];
    }
}

@end
