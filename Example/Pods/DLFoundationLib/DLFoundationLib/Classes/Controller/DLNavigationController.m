//
//  DLNavigationController.m
//  PocketSLH
//
//  Created by GaoYuJian on 16/7/30.
//
//

#import "DLNavigationController.h"
#import "DLPopGestureDelegate.h"

@interface DLNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation DLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
//    self.useSystemBackBarButtonItem = YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.childViewControllers.count <= 1) {
        return NO;
    }
    
    if ([self.topViewController conformsToProtocol:@protocol(DLPopGestureDelegate)]) {
        id<DLPopGestureDelegate> topViewController = (id<DLPopGestureDelegate>) self.topViewController;
        if ([topViewController respondsToSelector:@selector(popGestureRecongnizerShouldBegin)]) {
            return [topViewController popGestureRecongnizerShouldBegin];
        }
    }
    
    return YES;
}

@end
