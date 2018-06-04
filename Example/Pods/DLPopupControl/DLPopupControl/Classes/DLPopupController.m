//
//  DLPopupController.m
//  Test
//
//  Created by yjj on 2017/6/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "DLPopupController.h"
#import "DLPopupContainerViewController.h"
#import "DLPopupHorizontalAnimator.h"
#import "DLPopupVerticalAnimator.h"
#import "DLPopupCenterFormAnimator.h"
#import "UIViewController+DLPopup.h"

@import Masonry;

@interface UIViewController (DLTInternal)

@property (nonatomic, strong, readwrite) DLPopupController *popupController;

@end

#pragma mark -- 

@interface DLPopupController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UIGestureRecognizerDelegate>

/**
 实际展示的内容控制器
 */
@property (nonatomic, strong, readwrite) UIViewController *contentViewController;

/**
 容器控制器
 */
@property (nonatomic, strong, readwrite) UIViewController *containerViewController;

@property (nonatomic, strong) UIViewController *presentingViewController;

/**
 动画的配置信息
 */
@property (nonatomic, strong, readwrite) DLPopupAnimationConfigureItem *configItem;

@end

@implementation DLPopupController

#pragma mark - life cycle 

- (instancetype)init {
    [NSException raise:@"require designated initializer" format:@"must use initWithRootViewController:"];
    return nil;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        self.contentViewController = rootViewController;
        rootViewController.popupController = self;
        self.configItem = [[DLPopupAnimationConfigureItem alloc] init];
    }
    return self;
}

#pragma mark - User Interaction

- (void)bgViewDidTap:(UIGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:gesture.view];
    if (!CGRectContainsPoint(_contentViewController.view.frame, tapPoint)) {
        [self dismiss];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning 

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // 执行转场动画
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 保持转场控制器的Frame一致
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    
    // 获取需要转场的控制器的上下文对象
    DLPopupAnimationTransitionContext *privateTransitionContext = [self convertTransitioningContext:transitionContext];
    id<DLPopupTransition> animator = [self animator];
    
    // 1.容器视图控制器的转场动画     // 2.执行真正需要转场是控制器的动画
    if (privateTransitionContext.transitionType == DLPopupControlTransitionPresent) {
        [transitionContext.containerView addSubview:toViewController.view];
        CGFloat lastBackgroundViewAlpha = toViewController.view.alpha;
        toViewController.view.alpha = 0;
        toViewController.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:[animator transitionDuration:privateTransitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toViewController.view.alpha = lastBackgroundViewAlpha;
            [toViewController setNeedsStatusBarAppearanceUpdate];
        } completion:nil];
        
        [toViewController addChildViewController:_contentViewController];
        [toViewController.view addSubview:_contentViewController.view];
        [_contentViewController didMoveToParentViewController:toViewController];
        [self layoutContainerViewWithSuperView:toViewController.view];
        [animator popupControllerAnimateWithContext:privateTransitionContext compelete:^{
            toViewController.view.userInteractionEnabled = YES;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }else {
        // dismiss
        fromViewController.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:[animator transitionDuration:privateTransitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromViewController.view.alpha = 0;
        } completion:nil];

        [toViewController willMoveToParentViewController:nil];
        [animator popupControllerAnimateWithContext:privateTransitionContext compelete:^{
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [_contentViewController.view removeFromSuperview];
            [_contentViewController removeFromParentViewController];
            [fromViewController.view removeFromSuperview];
        }];
    }
}

- (id<DLPopupTransition>)animator {
    id<DLPopupTransition> animator = nil;
    switch (self.configItem.popupType) {
        case DLPopupTypeLeftSheet:
        case DLPopupTypeRightSheet:
            animator = [DLPopupHorizontalAnimator new];
            break;
        case DLPopupTypeTopSheet:
        case DLPopupTypeBottomSheet:
            animator = [DLPopupVerticalAnimator new];
            break;
        case DLPopupTypeFormCenter:
            animator = [DLPopupCenterFormAnimator new];
            break;
        case DLPopupTypeCustom:
            animator = self.customPopupTransition;
            break;
            
        default:
            break;
    }
    return animator;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint tapPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
    return !CGRectContainsPoint(_contentViewController.view.frame, tapPoint);
}

#pragma mark - UI Layout

- (void)layoutContainerViewWithSuperView:(UIView *)superView {
    CGSize contentSizeOfTopView = [self contentSizeOfTopView];
    CGRect superFrame = superView.frame;
    
    if (self.configItem.popupType == DLPopupTypeCustom) {
        if (self.customLayoutContainerViewBlock) {
            self.customLayoutContainerViewBlock(_contentViewController.view, contentSizeOfTopView);
        }
        return;
    }
    
    BOOL isUseConstraint = NO;
    // 通过约束进行布局
    if (contentSizeOfTopView.width == 0 || contentSizeOfTopView.height == 0) {
        isUseConstraint = YES;
    }
    
    CGFloat containerViewWidth = contentSizeOfTopView.width;
    CGFloat containerViewHeight = contentSizeOfTopView.height;
    CGFloat containerViewX = 0;
    CGFloat containerViewY = 0;
    switch (self.configItem.popupType) {
        case DLPopupTypeTopSheet:
        {
            if (isUseConstraint) {
                [_contentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.top.equalTo(superView);
                }];
            } else {
                containerViewY = 0;
                containerViewX = (superFrame.size.width - containerViewWidth) / 2.0;
            }
        }
            break;
        case DLPopupTypeBottomSheet:
        {
            if (isUseConstraint) {
                [_contentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.bottom.equalTo(superView);
                }];
            } else {
                containerViewY = superFrame.size.height - containerViewHeight;
                containerViewX = (superFrame.size.width - containerViewWidth) / 2.0;
            }
        }
            break;
        case DLPopupTypeLeftSheet:
        {
            if (isUseConstraint) {
                [_contentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.equalTo(superView);
                }];
            } else {
                containerViewY = 0;
                containerViewX = 0;
            }
        }
            break;
        case DLPopupTypeRightSheet:
        {
            if (isUseConstraint) {
                [_contentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.top.equalTo(superView);
                }];
            } else {
                containerViewY = 0;
                containerViewX = superFrame.size.width - containerViewWidth;
            }
        }
            break;
        case DLPopupTypeFormCenter:
        {
            if (isUseConstraint) {
                [_contentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(superView);
                }];
            } else {
                containerViewY = (superFrame.size.height - containerViewHeight) / 2.0;
                containerViewX = (superFrame.size.width - containerViewWidth) / 2.0;
            }
        }
            break;
            
        default:
            break;
    }
    
    if (isUseConstraint) {
        [superView layoutIfNeeded];
    } else {
        _contentViewController.view.frame = CGRectMake(containerViewX, containerViewY, containerViewWidth, containerViewHeight);
    }
}

- (CGSize)contentSizeOfTopView {
    return _contentViewController.contentSizeInPopup;
}

#pragma mark - show & dismiss

- (void)presentInViewController:(UIViewController *)viewController {
    [self presentInViewController:viewController compelete:nil];
}

- (void)presentInViewController:(UIViewController *)viewController compelete:(void(^)(void))compelete {
    if (self.presented) {
        return;
    }
    
    if (viewController.tabBarController) {
        viewController = viewController.tabBarController;
    }
    
    viewController.popupController = self;
    self.presentingViewController = viewController;
    [viewController presentViewController:self.containerViewController animated:YES completion:^{
        if (self.popupControllerDidAppear) {
            self.popupControllerDidAppear();
        }
        if (compelete) {
            compelete();
        }
    }];
    
}

- (void)dismiss {
    [self dismissWithCompelete:nil];
}

- (void)dismissWithCompelete:(void(^)(void))compelete {
    self.presentingViewController.popupController = nil;
    self.contentViewController.popupController = nil;
    [_containerViewController dismissViewControllerAnimated:YES completion:^{
        if (self.popupControllerDidDismiss) {
            self.popupControllerDidDismiss();
        }
        
        if (compelete) {
            compelete();
        }
    }];
}

#pragma mark - Help

- (UIViewController *)containerViewControler {
    if (!_containerViewController) {
        UIViewController *containerViewControler = [[DLPopupContainerViewController alloc] init];
        containerViewControler.view.backgroundColor = self.configItem.maskBackgroundColor;
        
        // 点击背景视图自动隐藏
        if (self.configItem.enableAutoDismissWhenClickBackground == YES) {
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewDidTap:)];
            gesture.delegate = self;
            [containerViewControler.view addGestureRecognizer:gesture];
        }
        
        containerViewControler.transitioningDelegate = self;
        if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
            containerViewControler.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        } else {
            containerViewControler.modalPresentationStyle = UIModalPresentationCustom;
        }
        _containerViewController = containerViewControler;
    }
    return _containerViewController;
}

/**
 获取转场的上下文对象

 @param transitionContext 系统转场的上下文对象
 @return 上下文对象
 */
- (DLPopupAnimationTransitionContext *)convertTransitioningContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    DLPopupControlTransitionType transitionType;
    if ([transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] == _containerViewController) {
        transitionType = DLPopupControlTransitionPresent;
    } else {
        transitionType = DLPopupControlTransitionDismiss;
    }
    DLPopupAnimationTransitionContext *context = [[DLPopupAnimationTransitionContext alloc] initWithContainerView:_contentViewController.view transitionType:transitionType];
    context.configItem = self.configItem;
    return context;
}

/**
 容器视图控制器是否已经被展示出来了

 @return 是否
 */
- (BOOL)presented {
    return self.containerViewControler.presentingViewController != nil;
}

@end
