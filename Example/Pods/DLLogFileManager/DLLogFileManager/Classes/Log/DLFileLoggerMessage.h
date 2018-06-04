//
//  DLFileLoggerMessage.h
//  PocketSLH
//
//  Created by sml2 on 17/2/5.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger,DLFileLoggerMessageType) {
    DLFileLoggerMessageTypeLog,// .log
    DLFileLoggerMessageTypeZip // .zip
};

extern NSString *const kDLLogFileSuffixLog;

extern NSString *const kDLLogFileSuffixZip;

@interface DLFileLoggerMessage : NSObject

@property (nonatomic, assign,readonly) DLFileLoggerMessageType type;

@property (nonatomic, copy,readonly) NSString *fullPath;
/** 文件的上传路径 */
@property (nonatomic, copy,readonly) NSString *zipFilePath;

- (instancetype)initWithType:(DLFileLoggerMessageType )type fullPath:(NSString *)fullPath;

@end
