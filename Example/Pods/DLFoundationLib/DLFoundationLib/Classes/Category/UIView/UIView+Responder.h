//
//  UIView+Responder.h
//  PocketSLH
//
//  Created by yunyu on 16/1/21.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Responder)

/**
 * @abstract view's viewController if the view has one
 */
- (UIViewController *)dl_viewController;

/**
 * @abstract 递归查找view的nextResponder，直到找到类型为class的Responder
 *
 * @param class  nextResponder 的 class
 * @return       第一个满足类型为class的UIResponder
 */
- (UIResponder *)nextResponderWithClass:(Class) class;

/// 查找firstResponder
- (UIResponder *)findFirstResponder;

@end
