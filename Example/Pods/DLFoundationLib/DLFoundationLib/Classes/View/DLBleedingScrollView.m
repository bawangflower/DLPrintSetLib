//
//  DLBleedingScrollView.m
//  PocketSLH
//
//  Created by yunyu on 16/5/3.
//
//

#import "DLBleedingScrollView.h"

@interface DLBleedingScrollView () <UIScrollViewDelegate>

/**
 *  分页宽度
 */
@property (nonatomic, assign) CGFloat pageWidth;

/**
 *  页面间距
 */
@property (nonatomic, assign) CGFloat padding;

@end

@implementation DLBleedingScrollView

/**
 *  @param pageWidth 分页宽度
 *  @param padding   页面间距
 *
 *  @return
 */
- (instancetype)initWithPageWidth:(CGFloat)pageWidth padding:(CGFloat)padding {
    self = [super init];
    if (self) {
        self.pageWidth = pageWidth;
        self.padding = padding;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetPoint = *targetContentOffset;
    
    if ((targetPoint.x - (scrollView.contentSize.width - scrollView.frame.size.width)) >= -0.001 || targetPoint.x <= 0) {
        
    } else {
        NSInteger page = roundf(targetPoint.x / (_pageWidth + _padding));
        targetContentOffset->x = page * (_pageWidth + _padding);
    }
}

@end
