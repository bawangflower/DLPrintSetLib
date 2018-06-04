//
//  NSObject+DLDataConvert.h
//  PocketSLH
//
//  Created by GaoYuJian on 17/1/13.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (DLDataConvert)

/**
 将字典转换为对象,默认把key转换为propery
 具体映射规则可参考NSObject+DLJSONSerializing.h
 
 @param dict
 @return
 */
+ (instancetype)dl_objectWithDict:(NSDictionary *)dict;

/**
 *  拷贝指定的对象
 *
 *  @param object
 *
 *  @return
 */
+ (instancetype)dl_objectWithObject:(id)object;

/**
 把字典转换为对象
 
 @param object
 @return
 */
+ (NSDictionary *)dl_dictWithObject:(id)object;

@end
