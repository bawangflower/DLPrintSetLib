//
//  DLBleedingScrollView.h
//  PocketSLH
//
//  Created by yunyu on 16/5/3.
//
//

#import <UIKit/UIKit.h>

@interface DLBleedingScrollView : UIScrollView

/**
 *  @param pageWidth 分页宽度
 *  @param padding   页面间距
 *
 *  @return
 */
- (instancetype)initWithPageWidth:(CGFloat)pageWidth padding:(CGFloat)padding;

@end
