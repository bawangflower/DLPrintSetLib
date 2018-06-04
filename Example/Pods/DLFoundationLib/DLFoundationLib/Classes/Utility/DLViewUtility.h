//
//  DLViewUtility.h
//  PocketSLH
//
//  Created by dlsoft on 14/12/4.
//
//

#import <UIKit/UIKit.h>
#import "DLBlockType.h"
#import "DLAlertItem.h"
#import "DLAlertViewConfig.h"
@interface DLViewUtility : NSObject

#pragma mark - show

+ (void)show;

+ (void)showOnView:(UIView *)superView;

+ (void)showWithMessage:(NSString *)message;

+ (void)showWithMessage:(NSString *)message onView:(UIView *)superView;

+ (void)showSuccessWithMessage:(NSString *)message;

+ (void)showSuccessWithMessage:(NSString *)message onView:(UIView *)superView;

+ (void)showErrorWithMessage:(NSString *)message delay:(NSTimeInterval)delay;

+ (void)showErrorWithMessage:(NSString *)message;

+ (void)showErrorWithMessage:(NSString *)message onView:(UIView *)superView;

+ (void)showSuccessWithMessage:(NSString *)message delay:(NSTimeInterval)delay view:(UIView *)superView;

+ (void)toastWithMessage:(NSString *)message delay:(NSTimeInterval)delay;

+ (void)toastWithMessage:(NSString *)message delay:(NSTimeInterval)delay onView:(UIView *)superView;

#pragma mark - dismiss

+ (void)dismiss;

+ (void)dismissOnView:(UIView *)superView;

#pragma mark - alert

+ (void)showAlertMessage:(NSString *)message;

+ (void)showErrorMessageWithAlert:(NSString *)message;

+ (void)alertViewWithMessage:(NSString *)message callBack:(CallBackBlock)callBack;

+ (void)alertViewWithMessage:(NSString *)message cancelCallBack:(CallBackBlock)cancelCallBack confirmCallBack:(CallBackBlock)confirmCallBack;

+ (void)alertViewWithMessage:(NSString *)message onView:(UIView *)attachView callBack:(CallBackBlock)callBack;

/**
 只显示确认按钮
 
 @param message
 @param callBack
 */
+ (void)alertViewWithMessage:(NSString *)message confirmCallBack:(CallBackBlock)callBack;

/**
 只显示确认按钮
 
 @param message
 @param callBack
 */
+ (void)alertViewWithMessage:(NSString *)message onView:(UIView *)attachView confirmCallBack:(CallBackBlock)callBack;

+ (void)alertViewWithMessage:(NSString *)message onView:(UIView *)attachView cancelCallBack:(CallBackBlock)cancelCallBack confirmCallBack:(CallBackBlock)confirmCallBack;

+ (void)sheetViewWithTitle:(NSString *)title messages:(NSArray *)messages callBacks:(NSArray *)callBacks;

+ (void)inputViewWithTitle:(NSString *)title detail:(NSString *)detail placeholder:(NSString *)placeholder confirmCallBack:(CompletionBlock)confirmCallBack;

#pragma mark - System Alert

/**
 只显示确认按钮
 
 @param message
 @param callBack
 */
+ (void)systemAlertWithMessage:(NSString *)message confirmCallBack:(DLAlertHandler)callBack;
+ (void)systemAlertWithMessage:(NSString *)message callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)callBack;

/**
 取消、确认弹框
 
 @param message
 @param callBack 确认按钮回调
 */
+ (void)systemAlertWithMessage:(NSString *)message callBack:(DLAlertHandler)callBack;
+ (void)systemAlertWithMessage:(NSString *)message callerResponder:(UIResponder *)caller callBack:(DLAlertHandler)confirmCallBack;
+ (void)systemAlertWithMessage:(NSString *)message confirmCallBack:(DLAlertHandler)confirmCallBack cancelCallBack:(DLAlertHandler)cancelCallBack;
+ (void)systemAlertWithMessage:(NSString *)message callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)confirmCallBack cancelCallBack:(DLAlertHandler)cancelCallBack;



/**
 可以自定义 标题 内容 取消按钮标题 确定按钮标题 的Alert

 @param title          标题 默认：提示信息
 @param message        自定义
 @param confirmTitle   确定按钮 默认：确认
 @param cancelTitle    取消按钮 默认：取消
 @param confirmCallBack  确定的回调
 @param cancelCallBack   取消的回调
 */
+ (void)systemAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmCallBack:(DLAlertHandler)confirmCallBack cancelCallBack:(DLAlertHandler)cancelCallBack;

+ (void)systemAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)confirmCallBack cancelCallBack:(DLAlertHandler)cancelCallBack;

/**
 可以自定义 标题 内容 确定按钮标题 的Alert
 
 @param title          标题 默认：提示信息
 @param message        自定义
 @param confirmTitle   确定按钮 默认：确认
 @param confirmCallBack  确定的回调
 */
+ (void)systemAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmCallBack:(DLAlertHandler)confirmCallBack;

+ (void)systemAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)confirmCallBack;

/**
 系统输入弹框组件
 
 @param title
 @param message
 @param placeholder
 @param callBack
 */
+ (void)systemInputAlertWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder confirmCallBack:(DLAlertHandler)callBack;
+ (void)systemInputAlertWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)callBack;

/**
 系统数字输入弹框组件
 
 @param title
 @param message
 @param callBack
 */
+ (void)systemNumInputAlertWithTitle:(NSString *)title message:(NSString *)message confirmCallBack:(DLAlertHandler)callBack;
+ (void)systemNumInputAlertWithTitle:(NSString *)title message:(NSString *)message callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)callBack;

/**
 系统输入弹框组件
 
 @param title
 @param message
 @param configurationHandler 配置textField
 @param callBack
 */
+ (void)systemInputAlertWithTitle:(NSString *)title message:(NSString *)message configurationHandler:(void (^)(UITextField *textField))configurationHandler confirmCallBack:(DLAlertHandler)callBack;
+ (void)systemInputAlertWithTitle:(NSString *)title message:(NSString *)message callerResponder:(UIResponder *)caller configurationHandler:(void (^)(UITextField *textField))configurationHandler confirmCallBack:(DLAlertHandler)callBack;

/**
 系统sheet组件
 
 @param title
 @param items
 */
+ (void)systemSheetWithTitle:(NSString *)title items:(NSArray <DLAlertItem *> *)items;
+ (void)systemSheetWithTitle:(NSString *)title items:(NSArray <DLAlertItem *> *)items callerResponder:(UIResponder *)caller;

@end
