//
//  DLPopupAnimationTransitionContext.h
//  Pods
//
//  Created by yjj on 2017/6/12.
//
//  转场动画的上下文

#import <Foundation/Foundation.h>
#import "DLPopupAnimationConfigureItem.h"

typedef NS_ENUM(NSUInteger, DLPopupControlTransitionType) {
    DLPopupControlTransitionPresent, // 显示
    DLPopupControlTransitionDismiss  // 隐藏
};

@interface DLPopupAnimationTransitionContext : NSObject

- (instancetype)initWithContainerView:(UIView *)containerView transitionType:(DLPopupControlTransitionType)transitionType;


/**
 转场的类型  显示/隐藏
 */
@property (nonatomic, assign) DLPopupControlTransitionType transitionType;

/**
 执行动画的容器视图视图
 */
@property (nonatomic, weak) UIView *containerView;

/**
 背景视图
 */
@property (nonatomic, weak) UIView *backgroundView;

/**
 配置信息
 */
@property (nonatomic, weak) DLPopupAnimationConfigureItem *configItem;

@end
