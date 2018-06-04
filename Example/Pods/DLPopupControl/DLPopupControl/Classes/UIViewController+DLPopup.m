//
//  UIViewController+DLPopup.m
//  Pods
//
//  Created by yjj on 2017/6/13.
//
//

#import "UIViewController+DLPopup.h"
#import "DLPopupController.h"
#import <objc/runtime.h>

@implementation UIViewController (DLPopup)

- (void)setContentSizeInPopup:(CGSize)contentSizeInPopup {
    objc_setAssociatedObject(self, @selector(contentSizeInPopup), [NSValue valueWithCGSize:contentSizeInPopup], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)contentSizeInPopup {
    return [objc_getAssociatedObject(self, @selector(contentSizeInPopup)) CGSizeValue];
}

- (void)setPopupController:(DLPopupController *)popupController {
    objc_setAssociatedObject(self, @selector(popupController), popupController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DLPopupController *)popupController {
    return objc_getAssociatedObject(self, @selector(popupController));
}

@end
