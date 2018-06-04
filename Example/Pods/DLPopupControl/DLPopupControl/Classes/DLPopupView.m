//
//  DLPopupView.m
//  Pods
//
//  Created by yjj on 2017/6/14.
//
//

#import "DLPopupView.h"
#import "UIViewController+DLPopup.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

@interface DLPopupContentViewController : UIViewController

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) void(^viewDidLoadBlock)(void);

@property (nonatomic, weak) DLPopupAnimationConfigureItem *configItem;

@end

@implementation DLPopupContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.viewDidLoadBlock) {
        self.viewDidLoadBlock();
    }
}

- (UIView *)contentView {
    return self.view;
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.configItem.hiddenStatusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end

#pragma mark -

@interface DLPopupView ()

/**
  自定义的视图加载在该视图控制器上
 */
@property (nonatomic, strong) DLPopupContentViewController *contentViewController;

@property (nonatomic, strong, readwrite) DLPopupController *popupController;

@end

@implementation DLPopupView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // 初始化Popup 控制器
    self.popupController = [[DLPopupController alloc] initWithRootViewController:self.contentViewController];
    __weak typeof(self) weakSelf = self;
    self.popupController.popupControllerDidDismiss = ^ {
        weakSelf.popupController = nil;
    };
    self.contentViewController.configItem = self.configItem;
}

#pragma mark - show & dismiss
- (void)showInCallerViewController:(UIViewController *)viewController {
    objc_setAssociatedObject(self.popupController, _cmd, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.popupController presentInViewController:viewController compelete:nil];
}

/**
 子类在该方法中进行布局操作
 */
- (void)viewDidLoad {}

- (void)dismiss {
    [self.popupController dismiss];
}

#pragma mark - Getter & Setter

- (DLPopupContentViewController *)contentViewController {
    if (!_contentViewController) {
        _contentViewController = [[DLPopupContentViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        [_contentViewController setViewDidLoadBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf viewDidLoad];
        }];
    }
    return _contentViewController;
}
- (void)setContentViewSize:(CGSize)contentViewSize {
    _contentViewSize = contentViewSize;
    self.contentViewController.contentSizeInPopup = contentViewSize;
}

- (DLPopupAnimationConfigureItem *)configItem {
    return self.popupController.configItem;
}

- (UIView *)contentView {
    return self.contentViewController.contentView;
}

@end
