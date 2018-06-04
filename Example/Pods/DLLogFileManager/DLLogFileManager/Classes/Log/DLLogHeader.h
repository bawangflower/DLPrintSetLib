//
//  DLLogHeader.h
//  PocketSLH
//
//  Created by sml2 on 17/2/6.
//
//

#ifndef DLLogHeader_h
#define DLLogHeader_h

#import "DLLogManager.h"
#import "DLFileLoggerMessage.h"
#import "DLLogger.h"
#import "DLFileLogger.h"


#define DLLog(frmt, ...)    DLLOG_MAYBE(frmt, ##__VA_ARGS__)

#endif /* DLLogHeader_h */
