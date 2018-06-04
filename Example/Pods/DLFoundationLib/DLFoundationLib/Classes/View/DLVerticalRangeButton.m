//
//  DLVerticalRangeButton.m
//  PocketSLH
//
//  Created by yunyu on 16/4/19.
//
//

#import "DLVerticalRangeButton.h"

@interface DLVerticalRangeButton ()

@property (nonatomic, assign, readwrite) BOOL highlightedFlag;

@end

@implementation DLVerticalRangeButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGSize imageSize = [super imageRectForContentRect:contentRect].size;
    return CGRectMake((CGRectGetWidth(contentRect) - imageSize.width) / 2.0, 10, imageSize.width, imageSize.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGSize titleSize = [super titleRectForContentRect:contentRect].size;
    return CGRectMake(0, CGRectGetHeight(contentRect) - titleSize.height, self.bounds.size.width, titleSize.height);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:NO];
}

@end
