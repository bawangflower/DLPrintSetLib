//
//  NSString+DLCategory.m
//  PocketSLH
//
//  Created by yunyu on 16/1/28.
//
//

#import "NSString+DLCategory.h"
#import <UIKit/UIKit.h>

@implementation NSString (DLCategory)

/**
 *  @author GaoYuJian, 16-01-28 14:01:46
 *
 *  计算指定的子字符串匹配的数量
 *
 *  @param subString
 *
 *  @return
 */
- (NSUInteger)countOfSubString:(NSString *)subString {
    NSRegularExpression *rgex = [NSRegularExpression regularExpressionWithPattern:subString options:kNilOptions error:NULL];
    
    return [rgex numberOfMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length)];
}

/**
 *  @author Shenjun, 16-03-02 14:03:37
 *
 *  判断 是否 为空串
 *
 *  @return yes 表示空 no 表示 非空
 */
- (BOOL)isBlankString;
{
    if (self == nil || self == NULL)
    {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    if([self isEqualToString:@"<null>"])
    {
        return YES;
    }
    if([self isEqualToString:@"(null)"])
    {
        return YES;
    }
    
    return NO;
}



@end
