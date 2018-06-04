//
//  DLPopupTransition.h
//  Pods
//
//  Created by yjj on 2017/6/13.
//
//  实现动画的类需要实现的协议

#import "DLPopupAnimationTransitionContext.h"
#import <UIKit/UIKit.h>

#ifndef DLPopupTransition_h
#define DLPopupTransition_h

@protocol DLPopupTransition <NSObject>

- (NSTimeInterval)transitionDuration:(DLPopupAnimationTransitionContext *)context;

- (void)popupControllerAnimateWithContext:(DLPopupAnimationTransitionContext *)context compelete:(void(^)(void))compelete;

@end

#endif /* DLPopupTransition_h */
