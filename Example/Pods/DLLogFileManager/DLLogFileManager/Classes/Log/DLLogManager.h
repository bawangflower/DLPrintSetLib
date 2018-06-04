//
//  DLLogManager.h
//  PocketSLH
//
//  Created by sml2 on 17/2/5.
//
//

#import <Foundation/Foundation.h>
@class DLLogger,DLFileLogger,DLFileLoggerMessage;

typedef void(^DLLogUploadFileCompleteCallback)(BOOL success, NSError *error);

/**
 * 日志上传配置
 * @param filePath 日志路径
 * @param completeCallback 上传成功需要调用completeCallback(YES,nil) 上传失败需要调用completeCallback(NO,error);
 * @by sml
 */
typedef void(^DLLogUploadFileBlock)(NSString *filePath,DLLogUploadFileCompleteCallback completeCallback);

#define DLLOG_MACRO(fnct, frmt, ...) \
[DLLogManager logFile : __FILE__                                           \
function : fnct                                               \
line : __LINE__                                           \
format : (frmt), ## __VA_ARGS__]

#define DLLOG_MAYBE(frmt, ...) \
do { DLLOG_MACRO(__PRETTY_FUNCTION__, frmt, ##__VA_ARGS__); } while(0)

@interface DLLogManager : NSObject

/** 判断是否允许每天自动上传 default NO */
@property (nonatomic, assign) BOOL autoUploadEnable;
/** 是否重定向Log到日志文件 default NO */
@property (nonatomic, assign) BOOL redirectLogEnable;

@property (nonatomic, copy) DLLogUploadFileBlock uploadFileBlock;

+ (instancetype)sharedManager;

/**
 * 开启打印 默认不会开启每天自动上传
 * @by sml
 */
- (void)start;

/**
 * 所有的日志文件
 * @by sml
 */
- (NSArray<DLFileLoggerMessage *> *)logFiles;

/**
 * 上传指定的日志文件模型
 * @by sml
 */
- (void)uploadLogFileWithMessage:(DLFileLoggerMessage *)message;

- (void)uploadLogFileWithMessage:(DLFileLoggerMessage *)message completionHandler:(DLLogUploadFileCompleteCallback)completionHandler;

/**
 * 上传今天的日志文件
 * @by sml
 */
- (void)uploadTodayLogFileWithCompletionHandler:(DLLogUploadFileCompleteCallback)completionHandler;

/**
 * 上传指定日期的日志文件
 * @param date NSDate
 * @by sml
 */
- (void)uploadLogFileForDate:(NSDate *)date completionHandler:(DLLogUploadFileCompleteCallback)completionHandler;

+ (void)logFile:(const char *)file
       function:(const char *)function
           line:(NSUInteger)line
         format:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

@end
