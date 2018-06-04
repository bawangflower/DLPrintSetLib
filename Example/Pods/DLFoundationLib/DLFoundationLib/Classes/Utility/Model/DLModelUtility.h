//
//  DLModelUtility.h
//  PocketSLH
//
//  Created by yunyu on 16/1/5.
//
//

#import <Foundation/Foundation.h>

@interface DLModelUtility : NSObject

/**
 *  将指定的字典内容映射到指定的对象中
 *
 *  @param object 指定的对象
 *  @param dict   指定的字典
 */
+ (void)convertObject:(id)object dict:(NSDictionary *)dict;

/**
 *  将指定的对象转换为字典
 *
 *  @param object
 *
 *  @return
 */
+ (NSDictionary *)dictWithObject:(id)object;

/**
 *  拷贝指定的对象
 *
 *  @param object
 *
 *  @return
 */
+ (id)objectWithObject:(id)object;

@end
