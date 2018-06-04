//
//  UIImage+DLUtility.m
//  PocketSLH
//
//  Created by yunyu on 15/11/12.
//
//

#import "UIImage+DLUtility.h"

@implementation UIImage (DLUtility)

- (UIImage *)dl_resize:(CGSize)size {
    int W = size.width;
    int H = size.height;
   
    CGImageRef   imageRef   = self.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, W, H, 8, 4*W, colorSpaceInfo, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight){
        W = size.height;
        H = size.width;
    }
    
    if(self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored){
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -H);
    }
    else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored){
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -W, 0);
    }
    else if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationUpMirrored){
        // Nothing
    }
    else if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored){
        CGContextTranslateCTM (bitmap, W, H);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, W, H), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return newImage;
}

/**
 *  获取纯色图片 size(1,1)
 *
 *  @param color
 *
 *  @return
 */
+ (UIImage *)dl_imageWithColor:(UIColor *)color {
    return [self dl_imageWithColor:color size:CGSizeMake(1, 1) cornerRadius:0 title:nil];
}

/**
 *  绘制图片
 *
 *  @param color  颜色
 *  @param size   尺寸
 *  @param radius 圆角
 *
 *  @return
 */
+ (UIImage *)dl_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius {
    return [self dl_imageWithColor:color size:size cornerRadius:radius title:nil];
}

/**
 *  绘制图片
 *
 *  @param color  颜色
 *  @param size   尺寸
 *  @param radius 圆角
 *  @param title  属性文本
 *
 *  @return
 */
+ (UIImage *)dl_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius title:(NSAttributedString *)title {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, UIScreen.mainScreen.scale);
    if (radius > 0) {
        CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
        CGContextClip(UIGraphicsGetCurrentContext());
    }
    
    [color setFill];
    UIRectFill(rect);
   
    if (title.length > 0) {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *mutableTitle = [[NSMutableAttributedString alloc] initWithAttributedString:title];
        [mutableTitle addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutableTitle.length)];
        
        CGFloat titleY = radius - mutableTitle.size.height / 2.0;
        CGRect tilteRect = CGRectMake(0, titleY, radius * 2, radius * 2 - titleY);
        [mutableTitle drawInRect:tilteRect];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;

}

/**
 *  绘制一张带文本的圆形图片
 *
 *  @param color
 *  @param radius
 *  @param title
 *
 *  @return
 */
+ (UIImage *)dl_circleImageWithColor:(UIColor *)color radius:(CGFloat)radius title:(NSAttributedString *)title {
    return [self dl_imageWithColor:color size:CGSizeMake(2.0 * radius, 2.0 * radius) cornerRadius:radius title:title];
}

/**
 *  圆角图片
 *
 *  @param sizeToFit
 *  @param radius
 *
 *  @return
 */
- (UIImage *)dl_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius
{
    CGRect rect = (CGRect){0.f, 0.f, sizeToFit};
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}


@end
