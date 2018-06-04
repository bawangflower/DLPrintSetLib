//
//  DLPopupContainerViewController.m
//  Test
//
//  Created by yjj on 2017/6/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "DLPopupContainerViewController.h"
#import "DLPopupAnimationConfigureItem.h"

@interface DLPopupContainerViewController ()

@end

@implementation DLPopupContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.childViewControllers.count || !self.presentingViewController) {
        return [super preferredStatusBarStyle];
    }
    return [self.presentingViewController preferredStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.childViewControllers.lastObject;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.childViewControllers.lastObject;
}

@end
