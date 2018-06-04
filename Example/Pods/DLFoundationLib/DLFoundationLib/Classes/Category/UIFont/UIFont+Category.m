//
//  UIFont+Category.m
//  PocketSLH
//
//  Created by yunyu on 15/10/13.
//
//

#import "UIFont+Category.h"

@implementation UIFont (Category)

+ (UIFont *)BoldObliqueSystemFontOfSize:(CGFloat)fontSize {
    if (fontSize <= 0) {
        return nil;
    }
    NSDictionary *fontAttributes = @{
                                     UIFontDescriptorNameAttribute : @"Helvetica Neue",
                                     UIFontDescriptorFaceAttribute : @"Bold Italic",
                                     UIFontDescriptorSizeAttribute : @(fontSize),
                                     };
    
    UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:fontAttributes];
    return [UIFont fontWithDescriptor:fontDescriptor size:0];
}

@end
