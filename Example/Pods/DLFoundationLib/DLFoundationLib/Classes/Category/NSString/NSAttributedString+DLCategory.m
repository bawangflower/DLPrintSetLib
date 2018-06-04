//
//  NSAttributedString+DLCategory.m
//  PocketSLH
//
//  Created by 杭州东灵 on 16/3/7.
//
//

#import "NSAttributedString+DLCategory.h"

@implementation NSAttributedString (DLCategory)

/**
 *  @author Shenjun, 16-03-07 13:03:19
 *
 *  获得 字符串 size
 *
 *  @param font
 *  @param maxSize
 *
 *  @return 字符串 size
 */
- (CGSize)getNewSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    [attributedStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedStr.length)];
    
    return [attributedStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

@end
