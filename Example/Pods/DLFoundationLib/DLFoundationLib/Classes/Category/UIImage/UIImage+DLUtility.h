//
//  UIImage+DLUtility.h
//  PocketSLH
//
//  Created by yunyu on 15/11/12.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (DLUtility)

- (UIImage*)dl_resize:(CGSize)size;

/**
 *  获取纯色图片 size(1,1)
 *
 *  @param color
 *
 *  @return
 */
+ (UIImage *)dl_imageWithColor:(UIColor *)color;

/**
 *  圆角图片
 *
 *  @param sizeToFit
 *  @param radius
 *
 *  @return
 */
- (UIImage *)dl_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius;

/**
 *  绘制图片
 *
 *  @param color  颜色
 *  @param size   尺寸
 *  @param radius 圆角
 *
 *  @return
 */
+ (UIImage *)dl_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius;

/**
 *  绘制一张带文本的圆形图片
 *
 *  @param color
 *  @param radius
 *  @param title
 *
 *  @return
 */
+ (UIImage *)dl_circleImageWithColor:(UIColor *)color radius:(CGFloat)radius title:(NSAttributedString *)title;

@end
