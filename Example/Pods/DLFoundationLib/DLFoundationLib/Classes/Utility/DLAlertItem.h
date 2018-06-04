//
//  DLAlertItem.h
//  Pods
//
//  Created by GaoYuJian on 2017/4/21.
//
//

#import <Foundation/Foundation.h>

@class DLAlertItem;

typedef void (^DLAlertHandler)(id object);

@interface DLAlertItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) DLAlertHandler handler;

+ (instancetype)alertItemWithTitle:(NSString *)title handler:(DLAlertHandler)handler;

@end
