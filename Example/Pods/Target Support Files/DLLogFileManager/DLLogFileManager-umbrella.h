#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DLFileHandler.h"
#import "DLFileLogger.h"
#import "DLFileLoggerMessage.h"
#import "DLLogger.h"
#import "DLLogHeader.h"
#import "DLLogManager.h"

FOUNDATION_EXPORT double DLLogFileManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char DLLogFileManagerVersionString[];

