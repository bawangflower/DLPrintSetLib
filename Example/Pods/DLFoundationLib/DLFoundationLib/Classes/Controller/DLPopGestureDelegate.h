//
//  DLPopGestureDelegate.h
//  PocketSLH
//
//  Created by GaoYuJian on 16/7/30.
//
//  和DLNavigationController 配合使用 ,subViewController可以实现协议方法来拦截 pop返回手势

#import <Foundation/Foundation.h>

@protocol DLPopGestureDelegate <NSObject>

@optional

/**
 *  @author GaoYuJian
 *
 *  NavigationController 的 subViewController 实现拦截pop手势
 *
 *  @return
 */
- (BOOL)popGestureRecongnizerShouldBegin;

@end
