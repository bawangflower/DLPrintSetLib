//
//  UIViewController+DLPopup.h
//  Pods
//
//  Created by yjj on 2017/6/13.
//
//

#import <UIKit/UIKit.h>

@class DLPopupController;

@interface UIViewController (DLPopup)

@property (nonatomic, assign) CGSize contentSizeInPopup;

@property (nonatomic, strong, readonly) DLPopupController *popupController;

@end
