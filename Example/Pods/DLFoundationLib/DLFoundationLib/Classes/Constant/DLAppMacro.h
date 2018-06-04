//
//  DLAppMacro.h
//  PocketSLH
//
//  Created by yunyu on 16/4/28.
//
//

#ifndef DLAppMacro_h
#define DLAppMacro_h

#if TARGET_IPHONE_SIMULATOR
#define DLSimulator 1
#else
#define DLSimulator 0
#endif

#define WINDOW_FRAME   [UIApplication sharedApplication].keyWindow.frame
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE   [UIScreen mainScreen].scale

#define DL_USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define DL_NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]
#define DL_APPDocumentPath(path) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:path]


#define dispatch_main_thread_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#pragma mark - Data Process

#define getNotNilValue(value) ((value) ? (value) : @"")

#define setupDictValue(dict, key, value) if (key && value) { [dict setValue:value forKey:key];}

#define setupArrayValue(array, object) if (array && object) { [array addObject:object]; }

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#endif /* DLAppMacro_h */
