//
//  DLPrintSetUtility.m
//  AFNetworking
//
//  Created by LiYanQin on 2018/6/4.
//

#import "DLPrintSetUtility.h"

@implementation DLPrintSetUtility

/** pod 图片资源加载 */
+ (UIImage *)dl_bundleImageWithName:(NSString *)imageName {
    if (![imageName hasSuffix:@"@2x.png"]) {
        imageName = [imageName stringByAppendingString:@"@2x.png"];
    }

    NSString *bundleClassPath = [[NSBundle bundleForClass:NSClassFromString(@"DLPrintSetLib")] bundlePath];
    NSString *bundleName = [[[[bundleClassPath lastPathComponent] stringByDeletingPathExtension] componentsSeparatedByString:@"_"] firstObject];
    NSString *bundleDirectory = [bundleName stringByAppendingString:@".bundle"];
    
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:imageName ofType:@"" inDirectory:bundleDirectory];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

@end
