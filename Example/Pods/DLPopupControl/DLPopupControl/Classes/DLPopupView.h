//
//  DLPopupView.h
//  Pods
//
//  Created by yjj on 2017/6/14.
//
//

#import <UIKit/UIKit.h>
#import "DLPopupController.h"


/**
 便利类 为了适配项目中的已有模块  新的功能模块最好不要使用该类
 */
@interface DLPopupView : NSObject

/**
 动画的配置信息
 */
@property (nonatomic, strong, readonly) DLPopupAnimationConfigureItem *configItem;

@property (nonatomic, strong, readonly) DLPopupController *popupController;

/**
 需要显示内容的容器视图
 */
@property (nonatomic, strong, readonly) UIView *contentView;

/**
 自定义视图的大小
 */
@property (nonatomic, assign) CGSize contentViewSize;

#pragma mark - show & dismiss

/**
 在指定的视图控制器中显示出来

 @param viewController 指定视图控制器
 */
- (void)showInCallerViewController:(UIViewController *)viewController;

/**
 隐藏销毁
 */
- (void)dismiss;

/**
 子类在该方法中进行布局操作
 */
- (void)viewDidLoad;

@end
