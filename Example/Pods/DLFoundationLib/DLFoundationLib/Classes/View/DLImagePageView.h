//
//  DLImagePageView.h
//  PocketSLH
//
//  Created by yunyu on 16/3/18.
//
//

#import <UIKit/UIKit.h>

@interface DLImagePageView : UIView

/**
 lazy load , 可以设置theme
 */
@property (nonatomic, strong, readonly) UIPageControl *pageCtl;

- (instancetype)initWithURLs:(NSArray *)imageURLs;

@end
