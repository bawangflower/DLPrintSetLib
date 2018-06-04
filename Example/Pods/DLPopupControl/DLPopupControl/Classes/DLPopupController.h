//
//  DLPopupController.h
//  Test
//
//  Created by yjj on 2017/6/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLPopupTransition.h"
#import "DLPopupAnimationConfigureItem.h"

@interface DLPopupController : NSObject

#pragma mark - property

/**
 实际展示的内容控制器
 */
@property (nonatomic, strong, readonly) UIViewController *contentViewController;

/**
 动画的配置信息
 */
@property (nonatomic, strong, readonly) DLPopupAnimationConfigureItem *configItem;

/**
 视图是否已经显示出来了
 */
@property (nonatomic, assign, readonly) BOOL presented;

/**
 自定义转场 如果定义 configItem->popupType = DLPopupTypeCustom 需要自定义
 */
@property (nonatomic, strong) id<DLPopupTransition> customPopupTransition;

/**
 自定义转场是内容的布局
 @description containerView: 容器视图，contentViewSize：需要转场的视图的大小
 */
@property (nonatomic, copy) void(^customLayoutContainerViewBlock)(UIView *containerView, CGSize containerViewSize);

/**
 视图控制器将消失
 */
@property (nonatomic, copy) void(^popupControllerDidDismiss)(void);

/**
 视图控制器显示
 */
@property (nonatomic, copy) void(^popupControllerDidAppear)(void);

#pragma mark - init

/**
 通过需要显示的控制器来初始化Popup的控制器

 @param rootViewController 需要显示的控制器
 @return Instance
 */
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;


#pragma mark - show & dismiss

- (void)presentInViewController:(UIViewController *)viewController;

- (void)presentInViewController:(UIViewController *)viewController compelete:(void(^)(void))compelete;

- (void)dismiss;

- (void)dismissWithCompelete:(void(^)(void))compelete;

@end
