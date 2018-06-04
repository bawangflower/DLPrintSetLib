//
//  NSTimer+DLBlockSupport.h
//  PocketSLH
//
//  Created by 杭州东灵 on 16/8/2.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (DLBlockSupport)

+ (NSTimer *)DL_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;

@end
