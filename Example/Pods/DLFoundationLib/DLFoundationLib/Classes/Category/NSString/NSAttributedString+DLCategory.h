//
//  NSAttributedString+DLCategory.h
//  PocketSLH
//
//  Created by 杭州东灵 on 16/3/7.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (DLCategory)

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
- (CGSize)getNewSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
