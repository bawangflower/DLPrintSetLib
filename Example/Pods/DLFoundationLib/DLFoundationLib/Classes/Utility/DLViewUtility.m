//
//  DLViewUtility.m
//  PocketSLH
//
//  Created by dlsoft on 14/12/4.
//
//

#import "DLViewUtility.h"
#import "MBProgressHUD.h"
#import "Colours.h"
#import "DLAppMacro.h"
#import "UIWindow+DLCategory.h"
#import "NSBundle+DLFoundationLib.h"

#define MESSAGE_TIP DLLocalizedString(@"提示信息")
#define MESSAGE_ERROR DLLocalizedString(@"错误!")
#define MESSAGE_OK DLLocalizedString(@"确 定")
#define MESSAGE_CANCEL DLLocalizedString(@"取 消")

static NSTimeInterval const KDefaultHUDDelayTime = 2.0f;

@implementation DLViewUtility

#pragma mark - HUD

+ (void)show {
    [self showWithMessage:nil onView:nil];
}

+ (void)showOnView:(UIView *)superView {
    [self showWithMessage:nil onView:superView];
}

+ (void)showWithMessage:(NSString *)message {
    [self showWithMessage:message onView:nil];
}

+ (void)showAlertMessage:(NSString *)message {
    [self systemAlertWithMessage:message confirmCallBack:nil];
}

+ (void)showSuccessWithMessage:(NSString *)message {
    [self showSuccessWithMessage:message delay:2 view:nil];
}

+ (void)showSuccessWithMessage:(NSString *)message onView:(UIView *)superView {
    [self showSuccessWithMessage:message delay:2 view:superView];
}

+ (void)showSuccessWithMessage:(NSString *)message delay:(NSTimeInterval)delay view:(UIView *)superView {
    UIImage *image = [UIImage imageNamed:@"success_action" inBundle:[NSBundle dl_fundationLibImageBundle] compatibleWithTraitCollection:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self showCustomView:imageView text:message delay:delay view:superView];
}

+ (void)showErrorMessageWithAlert:(NSString *)message {
    [self systemAlertWithMessage:message title:MESSAGE_ERROR callerResponder:nil confirmCallBack:nil];
}

+ (void)showErrorWithMessage:(NSString *)message delay:(NSTimeInterval)delay {
    [self showErrorWithMessage:message delay:delay view:nil];
}

+ (void)showErrorWithMessage:(NSString *)message {
    [self showErrorWithMessage:message delay:0 view:nil];
}

+ (void)showErrorWithMessage:(NSString *)message onView:(UIView *)superView {
    [self showErrorWithMessage:message delay:0 view:superView];
}

+ (void)showErrorWithMessage:(NSString *)message delay:(NSTimeInterval)delay view:(UIView *)superView {
    UIImage *image = [UIImage imageNamed:@"error_action" inBundle:[NSBundle dl_fundationLibImageBundle] compatibleWithTraitCollection:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self showCustomView:imageView text:message delay:delay view:superView];
}

+ (void)showWithMessage:(NSString *)message onView:(UIView *)superView {
    if (!superView) {
        superView = [UIApplication sharedApplication].delegate.window;
    }
    
    dispatch_main_thread_async_safe(^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:superView];
        if (!hud) {
            hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        }
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = message;
    });
}

+ (void)showCustomView:(UIView *)customView text:(NSString *)text delay:(NSTimeInterval)delay view:(UIView *)superView {
    if (!superView) {
        superView = [UIApplication sharedApplication].delegate.window;
    }
    
    if (delay == 0) {
        delay = KDefaultHUDDelayTime;
    }
    
    dispatch_main_thread_async_safe(^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:superView];
        if (!hud) {
            hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        }
        if (customView) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = customView;
        }else {
            hud.mode = MBProgressHUDModeText;
        }
        hud.label.numberOfLines = 0;
        hud.label.text = text;
        [hud hideAnimated:YES afterDelay:delay];
    });
    
}

+ (void)toastWithMessage:(NSString *)message delay:(NSTimeInterval)delay {
    [self showCustomView:nil text:message delay:delay view:nil];
}

+ (void)toastWithMessage:(NSString *)message delay:(NSTimeInterval)delay onView:(UIView *)superView {
    [self showCustomView:nil text:message delay:delay view:superView];
}

+ (void)dismiss {
    [self dismissOnView:nil];
}

+ (void)dismissOnView:(UIView *)superView {
    if (!superView) {
        superView = [UIApplication sharedApplication].delegate.window;
    }
    
    dispatch_main_thread_async_safe(^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:superView];
        [hud hideAnimated:YES];
    });
}

#pragma mark - Message View

+ (void)alertViewWithMessage:(NSString *)message onView:(UIView *)attachView callBack:(CallBackBlock)callBack {
    [self systemAlertWithMessage:message callerResponder:attachView callBack:callBack];
}

+ (void)alertViewWithMessage:(NSString *)message callBack:(CallBackBlock)callBack {
    [self systemAlertWithMessage:message callBack:callBack];
}

/**
 只显示确认按钮
 
 @param message
 @param callBack
 */
+ (void)alertViewWithMessage:(NSString *)message confirmCallBack:(CallBackBlock)callBack {
    [self systemAlertWithMessage:message confirmCallBack:callBack];
}

/**
 只显示确认按钮

 @param message
 @param callBack
 */
+ (void)alertViewWithMessage:(NSString *)message onView:(UIView *)attachView confirmCallBack:(CallBackBlock)callBack {
    [self systemAlertWithMessage:message callerResponder:attachView callBack:callBack];
}

+ (void)alertViewWithMessage:(NSString *)message cancelCallBack:(CallBackBlock)cancelCallBack confirmCallBack:(CallBackBlock)confirmCallBack {
    [self alertViewWithMessage:message onView:nil cancelCallBack:cancelCallBack confirmCallBack:confirmCallBack];
}

+ (void)alertViewWithMessage:(NSString *)message onView:(UIView *)attachView cancelCallBack:(CallBackBlock)cancelCallBack confirmCallBack:(CallBackBlock)confirmCallBack {
    [self systemAlertWithMessage:message callerResponder:attachView confirmCallBack:^(id object) {
        if (confirmCallBack) {
            confirmCallBack();
        }
    } cancelCallBack:^(id object) {
        if (cancelCallBack) {
            cancelCallBack();
        }
    }];
}

+ (void)sheetViewWithTitle:(NSString *)title messages:(NSArray *)messages callBacks:(NSArray *)callBacks {
    if (!messages || !callBacks) {
        return;
    }
    NSAssert(messages.count == callBacks.count, @"消息数和回调block的数量不匹配");
    
    NSMutableArray<DLAlertItem *> *items = [NSMutableArray array];
    [messages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DLAlertItem *item = [DLAlertItem alertItemWithTitle:obj handler:[callBacks objectAtIndex:idx]];
        [items addObject:item];
    }];
    
    [self systemSheetWithTitle:title items:items];
}

+ (void)inputViewWithTitle:(NSString *)title detail:(NSString *)detail placeholder:(NSString *)placeholder confirmCallBack:(CompletionBlock)confirmCallBack {
    [self systemInputAlertWithTitle:title message:detail callerResponder:nil configurationHandler:^(UITextField *textField) {
        textField.placeholder = placeholder;
    } confirmCallBack:^(id object) {
        if (confirmCallBack) {
            confirmCallBack(object);
        }
    }];
}

#pragma mark - System Alert

/**
 只显示确认按钮
 
 @param message
 @param callBack
 */
+ (void)systemAlertWithMessage:(NSString *)message confirmCallBack:(DLAlertHandler)callBack {
    [self systemAlertWithMessage:message callerResponder:nil confirmCallBack:callBack];
}

+ (void)systemAlertWithMessage:(NSString *)message callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)callBack {
    [self systemAlertWithMessage:message title:MESSAGE_TIP callerResponder:caller confirmCallBack:callBack];
}

+ (void)systemAlertWithMessage:(NSString *)message title:(NSString *)title callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)callBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:MESSAGE_TIP message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[DLAlertViewConfig sharedConfig].defaultTextOK ?: MESSAGE_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (callBack) {
                callBack(nil);
            }
        }];
        [alert addAction:action];
        
        UIViewController *visibleController = [self visibleController:caller];
        [visibleController presentViewController:alert animated:YES completion:nil];
    });
}

/**
 取消、确认弹框

 @param message
 @param callBack 确认按钮回调
 */
+ (void)systemAlertWithMessage:(NSString *)message callBack:(DLAlertHandler)callBack {
    [self systemAlertWithMessage:message callerResponder:nil callBack:callBack];
}

+ (void)systemAlertWithMessage:(NSString *)message callerResponder:(UIResponder *)caller callBack:(DLAlertHandler)callBack {
    [self systemAlertWithMessage:message callerResponder:caller confirmCallBack:callBack cancelCallBack:nil];
}

+ (void)systemAlertWithMessage:(NSString *)message confirmCallBack:(DLAlertHandler)confirmCallBack cancelCallBack:(DLAlertHandler)cancelCallBack {
    [self systemAlertWithMessage:message callerResponder:nil confirmCallBack:confirmCallBack cancelCallBack:cancelCallBack];
}

+ (void)systemAlertWithMessage:(NSString *)message callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)callBack cancelCallBack:(DLAlertHandler)cancelCallBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:MESSAGE_TIP message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[DLAlertViewConfig sharedConfig].defaultTextOK ?: MESSAGE_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (callBack) {
                callBack(nil);
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[DLAlertViewConfig sharedConfig].defaultTextCancel ?: MESSAGE_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if(cancelCallBack) {
                cancelCallBack(nil);
            }
        }];
        [alert addAction:cancelAction];
        [alert addAction:confirmAction];
        UIViewController *visibleController = [self visibleController:caller];
        [visibleController presentViewController:alert animated:YES completion:nil];
    });
}

/**
 可以自定义 标题 内容 取消按钮标题 确定按钮标题 的Alert
 
 @param title          标题 默认：提示信息
 @param message        自定义
 @param confirmTitle   确定按钮 默认：确认
 @param cancelTitle    取消按钮 默认：取消
 @param confirmCallBack  确定的回调
 @param cancelCallBack   取消的回调
 */
+ (void)systemAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmCallBack:(DLAlertHandler)confirmCallBack cancelCallBack:(DLAlertHandler)cancelCallBack {
    [self systemAlertWithTitle:title message:message confirmTitle:confirmTitle cancelTitle:cancelTitle callerResponder:nil confirmCallBack:confirmCallBack cancelCallBack:cancelCallBack];
}

+ (void)systemAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)confirmCallBack cancelCallBack:(DLAlertHandler)cancelCallBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title?:MESSAGE_TIP message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle ?: MESSAGE_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (confirmCallBack) {
                confirmCallBack(nil);
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle ?: MESSAGE_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if(cancelCallBack) {
                cancelCallBack(nil);
            }
        }];
        [alert addAction:cancelAction];
        [alert addAction:confirmAction];
        UIViewController *visibleController = [self visibleController:caller];
        [visibleController presentViewController:alert animated:YES completion:nil];
    });
}

/**
 可以自定义 标题 内容 确定按钮标题 的Alert
 
 @param title          标题 默认：提示信息
 @param message        自定义
 @param confirmTitle   确定按钮 默认：确认
 @param confirmCallBack  确定的回调
 */
+ (void)systemAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmCallBack:(DLAlertHandler)confirmCallBack {
    [self systemAlertWithTitle:title message:message confirmTitle:confirmTitle callerResponder:nil confirmCallBack:confirmCallBack];
}

+ (void)systemAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)confirmCallBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title?:MESSAGE_TIP message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle?:MESSAGE_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (confirmCallBack) {
                confirmCallBack(nil);
            }
        }];
        [alert addAction:confirmAction];
        UIViewController *visibleController = [self visibleController:caller];
        [visibleController presentViewController:alert animated:YES completion:nil];
    });
}

/**
 系统输入弹框组件

 @param title
 @param message
 @param placeholder
 @param callBack
 */
+ (void)systemInputAlertWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder confirmCallBack:(DLAlertHandler)callBack {
    [self systemInputAlertWithTitle:title message:message configurationHandler:^(UITextField *textField) {
        textField.placeholder = placeholder;
    } confirmCallBack:callBack];
}

+ (void)systemInputAlertWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)callBack {
    [self systemInputAlertWithTitle:title message:message callerResponder:caller configurationHandler:^(UITextField *textField) {
        textField.placeholder = placeholder;
    } confirmCallBack:callBack];
}

/**
 系统数字输入弹框组件
 
 @param title
 @param message
 @param callBack
 */
+ (void)systemNumInputAlertWithTitle:(NSString *)title message:(NSString *)message confirmCallBack:(DLAlertHandler)callBack {
    [self systemInputAlertWithTitle:title message:message configurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    } confirmCallBack:callBack];
}

+ (void)systemNumInputAlertWithTitle:(NSString *)title message:(NSString *)message callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)callBack {
    [self systemInputAlertWithTitle:title message:message callerResponder:caller configurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    } confirmCallBack:callBack];
}

+ (void)systemNumInputAlertWithTitle:(NSString *)title placeholder:(NSString *)placeholder message:(NSString *)message callerResponder:(UIResponder *)caller confirmCallBack:(DLAlertHandler)callBack {
    [self systemInputAlertWithTitle:title message:message callerResponder:caller configurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.placeholder = placeholder;
    } confirmCallBack:callBack];
}


/**
 系统输入弹框组件

 @param title
 @param message
 @param configurationHandler 配置textField
 @param callBack
 */
+ (void)systemInputAlertWithTitle:(NSString *)title message:(NSString *)message configurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler confirmCallBack:(DLAlertHandler)callBack {
    [self systemInputAlertWithTitle:title message:message callerResponder:nil configurationHandler:configurationHandler confirmCallBack:callBack];
}

+ (void)systemInputAlertWithTitle:(NSString *)title message:(NSString *)message callerResponder:(UIResponder *)caller configurationHandler:(void (^)(UITextField *textField))configurationHandler confirmCallBack:(DLAlertHandler)callBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:[DLAlertViewConfig sharedConfig].defaultTextOK ?: MESSAGE_OK style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (callBack) {
                callBack([weakAlert.textFields firstObject].text);
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[DLAlertViewConfig sharedConfig].defaultTextCancel ?: MESSAGE_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        [alert addAction:confirmAction];
        
        [alert addTextFieldWithConfigurationHandler:configurationHandler];
        
        UIViewController *visibleController = [self visibleController:caller];
        [visibleController presentViewController:alert animated:YES completion:nil];
    });
}


/**
 系统sheet组件

 @param title
 @param items
 */
+ (void)systemSheetWithTitle:(NSString *)title items:(NSArray <DLAlertItem *> *)items {
    [self systemSheetWithTitle:title items:items callerResponder:nil];
}

+ (void)systemSheetWithTitle:(NSString *)title items:(NSArray <DLAlertItem *> *)items callerResponder:(UIResponder *)caller {
    if (items.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            for (DLAlertItem *item in items) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:item.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (item.handler) {
                        item.handler(item);
                    }
                }];
                [alert addAction:action];
            }
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[DLAlertViewConfig sharedConfig].defaultTextCancel ?: MESSAGE_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancelAction];
            
            UIViewController *visibleController = [self visibleController:caller];
            [visibleController presentViewController:alert animated:YES completion:nil];
        });
    }
}

#pragma mark - HELP 

+ (UIViewController *)visibleController:(UIResponder *)caller {
    UIViewController *visibleController;
    if (caller) {
        if ([caller isKindOfClass:[UIWindow class]]) {
            UIWindow *callerWindow = (UIWindow *)caller;
            visibleController = [callerWindow dl_visibleViewController];
        }else if ([caller isKindOfClass:[UIView class]]) {
            UIView *callerView = (UIView *)caller;
            //  获取视图所在的控制器
            UIViewController *vc;
            UIResponder *nextResponse;
            while ((nextResponse = [callerView nextResponder])) {
                if ([nextResponse isKindOfClass:[UIViewController class]]) {
                    vc = (UIViewController *)nextResponse;
                    break;
                }
            }
            if (vc) {
                visibleController = vc;
            }else {
                visibleController = [[UIApplication sharedApplication].delegate.window dl_visibleViewController];
            }
        }else {
            visibleController = (UIViewController *)caller;
        }
    }else {
        visibleController = [[UIApplication sharedApplication].delegate.window dl_visibleViewController];
    }
    
    return visibleController;
}


@end
