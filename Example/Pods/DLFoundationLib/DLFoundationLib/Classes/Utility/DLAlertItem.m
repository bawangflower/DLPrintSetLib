//
//  DLAlertItem.m
//  Pods
//
//  Created by GaoYuJian on 2017/4/21.
//
//

#import "DLAlertItem.h"

@implementation DLAlertItem

+ (instancetype)alertItemWithTitle:(NSString *)title handler:(DLAlertHandler)handler {
    DLAlertItem *item = [[DLAlertItem alloc] init];
    item.title = title;
    item.handler = handler;
    return item;
}

@end
