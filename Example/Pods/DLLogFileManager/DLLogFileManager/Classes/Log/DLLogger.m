//
//  DLLogger.m
//  PocketSLH
//
//  Created by sml2 on 17/2/5.
//
//

#import "DLLogger.h"

@implementation DLLogger

- (void)log:(NSString *)message
   fileName:(NSString *)fileName
functionName:(NSString *)functionName
       line:(NSUInteger)line
     thread:(NSString *)thread {
    NSLog(@"[%@] %@ [%ld] :%@",thread,functionName,line,message);
}

@end
