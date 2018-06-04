//
//  DLPopupAnimationConfigureItem.h
//  Pods
//
//  Created by yjj on 2017/6/8.
//
//  配置信息

#import <UIKit/UIKit.h>

/**
 Popver视图显示的位置

 - DLPopupTypeTopSheet:    上面
 - DLPopupTypeBottomSheet: 底部
 - DLPopupTypeLeftSheet:   左边
 - DLPopupTypeRightSheet:  右边
 - DLPopupTypeFormCenter:  中间
 - DLPopupTypeCustom:      自定义
*/
typedef NS_ENUM(NSUInteger, DLPopupType) {
    DLPopupTypeTopSheet,
    DLPopupTypeBottomSheet,
    DLPopupTypeLeftSheet,
    DLPopupTypeRightSheet,
    DLPopupTypeFormCenter,
    DLPopupTypeCustom
};

@interface DLPopupAnimationConfigureItem : NSObject

/**
 Popver视图显示的位置
 */
@property (nonatomic, assign) DLPopupType popupType;

/**
 视图显示需要的时间 默认0.5
 */
@property (nonatomic, assign) NSTimeInterval presentDuration;

/**
 视图隐藏需要的时间 默认0.25
 */
@property (nonatomic, assign) NSTimeInterval dismissDuration;

/**
 蒙板的背景颜色 默认:[[UIColor blackColor] colorWithAlphaComponent:0.5]
 */
@property (nonatomic, strong) UIColor *maskBackgroundColor;

/**
 点击背景视图是否隐藏 默认 YES
 */
@property (nonatomic, assign) BOOL enableAutoDismissWhenClickBackground;

/**
 是否隐藏StatusBar 
 */
@property (nonatomic, assign) BOOL hiddenStatusBar;

@end
