//
//  DLLogger.h
//  PocketSLH
//
//  Created by sml2 on 17/2/5.
//
//

#import <Foundation/Foundation.h>

@interface DLLogger : NSObject

- (void)log:(NSString *)message
   fileName:(NSString *)fileName
functionName:(NSString *)functionName
       line:(NSUInteger)line
     thread:(NSString *)thread;

@end
