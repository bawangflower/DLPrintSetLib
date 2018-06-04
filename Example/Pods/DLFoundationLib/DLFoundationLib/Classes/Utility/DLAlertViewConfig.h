//
//  DLAlertViewConfig.h
//  Pods
//
//  Created by GaoYuJian on 2017/4/21.
//
//  配置弹框组件样式

#import <Foundation/Foundation.h>

@interface DLAlertViewConfig : NSObject

/**
 弹框确定按钮文本，默认为'确 定'
 */
@property (nonatomic, copy) NSString *defaultTextOK;

/**
 弹框取消按钮文本，默认为'取 消'
 */
@property (nonatomic, copy) NSString *defaultTextCancel;

/**
 弹框item颜色
 */
@property (nonatomic, strong) UIColor *tintColor;

+ (instancetype)sharedConfig;

@end
