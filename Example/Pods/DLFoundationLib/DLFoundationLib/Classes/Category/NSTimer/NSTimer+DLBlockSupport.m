//
//  NSTimer+DLBlockSupport.m
//  PocketSLH
//
//  Created by 杭州东灵 on 16/8/2.
//
//

#import "NSTimer+DLBlockSupport.h"

@implementation NSTimer (DLBlockSupport)

+ (NSTimer *)DL_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(DL_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)DL_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}


@end
