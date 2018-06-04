//
//  NSObject+DLDataConvert.m
//  PocketSLH
//
//  Created by GaoYuJian on 17/1/13.
//
//

#import "NSObject+DLDataConvert.h"
#import "DLModelUtility.h"

@implementation NSObject (DLDataConvert)

/**
 将字典转换为对象,默认把key转换为propery
 具体映射规则可参考NSObject+DLJSONSerializing.h

 @param dict
 @return 
 */
+ (instancetype)dl_objectWithDict:(NSDictionary *)dict {
    NSObject *object = [[self alloc] init];
    [DLModelUtility convertObject:object dict:dict];
    return object;
}

/**
 *  拷贝指定的对象
 *
 *  @param object
 *
 *  @return
 */
+ (instancetype)dl_objectWithObject:(id)object {
    if ([object class] != self) {
        return nil;
    }
    return [DLModelUtility objectWithObject:object];
}


/**
 把字典转换为对象

 @param object
 @return
 */
+ (NSDictionary *)dl_dictWithObject:(id)object {
    if ([object class] != self) {
        return nil;
    }
    return [DLModelUtility dictWithObject:object];
}

@end
