//
//  NSString+DLCategory.h
//  PocketSLH
//
//  Created by yunyu on 16/1/28.
//
//

#import <Foundation/Foundation.h>

@interface NSString (DLCategory)

/**
 *  @author GaoYuJian, 16-01-28 14:01:46
 *
 *  计算指定的子字符串匹配的数量
 *
 *  @param subString
 *
 *  @return
 */
- (NSUInteger)countOfSubString:(NSString *)subString;

/**
 *  @author Shenjun, 16-03-02 14:03:37
 *
 *  判断 是否 为空串
 *
 *  @return yes 表示空 no 表示 非空
 */
- (BOOL)isBlankString;



@end
