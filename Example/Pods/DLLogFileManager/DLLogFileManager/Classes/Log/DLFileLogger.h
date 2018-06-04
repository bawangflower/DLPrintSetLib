//
//  DLFileLogger.h
//  PocketSLH
//
//  Created by sml2 on 17/2/5.
//
//

#import "DLLogger.h"
@class DLFileLoggerMessage;

@interface DLFileLogger : DLLogger

/** default 7 */
@property (nonatomic, assign) NSInteger maximumNumberOfLogFiles;

/**
 *  所有的日志文件
 *
 *  @author sml
 */
- (NSArray<DLFileLoggerMessage *> *)logFiles;

/**
 *  调用该方法之后，日志上传才能生效
 *
 *  @author sml
 */
- (void)configureLogger;

/**
 * 根据日期获取日志文件名
 * @param date NSDate
 * @return
 * @by sml
 */
- (NSString *)fileNameWithDate:(NSDate *)date;

/**
 * 上传所有未上传的日志文件
 * @by sml
 */
- (void)uploadUnarchiveFiles;

@end
