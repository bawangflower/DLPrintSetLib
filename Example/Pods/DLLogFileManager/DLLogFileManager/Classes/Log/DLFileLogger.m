//
//  DLFileLogger.m
//  PocketSLH
//
//  Created by sml2 on 17/2/5.
//
//

#import "DLFileLogger.h"
#import "DLFileLoggerMessage.h"
#import "DLFileHandler.h"
#import "DLLogManager.h"

static NSInteger const kSecondsOfOneDay = 24 * 60 * 60;

static NSString *const kDateFormatter = @"yyyy-MM-dd HH:mm:ss";


@interface DLFileLogger ()

@property (nonatomic, copy) NSString *logsDirectory;

@property (nonatomic, assign) BOOL onCreateFile;

@end
@implementation DLFileLogger

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _maximumNumberOfLogFiles = 7;
        _logsDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"DLLog"];
    }
    return self;
}

#pragma mark - Public

/**
 *  重写父类方法：将日志信息写入文件
 *
 *  @author sml
 */
- (void)log:(NSString *)message fileName:(NSString *)fileName functionName:(NSString *)functionName line:(NSUInteger)line thread:(NSString *)thread{
    if (!message) return;
    NSDate *date = [NSDate date];
    NSString *fileFullPath = [self fileFullPathWithFileName:[self fileNameWithDate:date] fileExtension:kDLLogFileSuffixLog];
    NSString *content = [NSString stringWithFormat:@"%@ [%@] %@[%ld] :%@",[self stringWithDate:date format:kDateFormatter],thread,functionName,line,[message stringByAppendingString:@"\n"]];
    [DLFileHandler appendingToFile:fileFullPath content:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)configureLogger {
    NSDate *date = [NSDate date];
    NSString *fullPath = [self fileFullPathWithFileName:[self fileNameWithDate:date] fileExtension:kDLLogFileSuffixLog];
    if (![DLFileHandler existFile:fullPath]) {
        // 当天第一次使用准备创建新文件
        [self willCreateLogFileAtPath:fullPath];
    } else {
        [self redirectNSlogToFile:fullPath];
    }
    // 差额定时器：触发时间为距离下一天的零点
    NSDate *tomorrowDate = [date dateByAddingTimeInterval:kSecondsOfOneDay];
    NSDate *startOfTomorrow = [[NSCalendar currentCalendar] startOfDayForDate:tomorrowDate];
    NSTimeInterval diffTime = [startOfTomorrow timeIntervalSinceDate:date];
    NSTimer *diffTimer = [NSTimer scheduledTimerWithTimeInterval:diffTime target:self selector:@selector(diffTimerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:diffTimer forMode:NSRunLoopCommonModes];
}


/**
 *  差额定时器触发事件
 *
 *  @author sml
 */
- (void)diffTimerAction:(NSTimer *)timer {
    NSString *fullPath = [self fileFullPathWithFileName:[self fileNameWithDate:[NSDate date]] fileExtension:kDLLogFileSuffixLog];
    [self willCreateLogFileAtPath:fullPath];
    // 重新开启一个24小时轮询定时器
    NSTimer *dayTimer = [NSTimer scheduledTimerWithTimeInterval:kSecondsOfOneDay target:self selector:@selector(dayTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:dayTimer forMode:NSRunLoopCommonModes];
    // 停止差额定时器
    [self stopTimer:timer];
}

/**
 *  24小时轮询定时器触发事件
 *
 *  @author sml
 */
- (void)dayTimerAction {
    NSString *fileName = [self fileNameWithDate:[NSDate date]];
    [DLFileHandler createFile:[self fileFullPathWithFileName:fileName fileExtension:kDLLogFileSuffixLog] content:nil];
    [self redirectNSlogToFile:[self fileFullPathWithFileName:fileName fileExtension:kDLLogFileSuffixLog]];
}

/**
 * 上传所有未上传的日志文件
 * @by sml
 */
- (void)uploadUnarchiveFiles {
    [self uploadUnarchiveFileInLogFiles:[self limitNumbersOfLogFile]];
}

#pragma mark - Internal Helper

- (void)willCreateLogFileAtPath:(NSString *)fileFullPath {
    [DLFileHandler createFile:fileFullPath content:nil];
    [self redirectNSlogToFile:fileFullPath];
    
    [self limitNumbersOfLogFile];
//    NSArray *logFiles = [self limitNumbersOfLogFile];
    
//    if (![DLLogManager sharedManager].autoUploadEnable) return;
//    [self uploadUnarchiveFileInLogFiles:logFiles];
}

/**
 *  限制log文件个数
 *  @return 所有的日志文件名称 包含.log和.zip
 *  @author sml
 */
- (NSArray<NSString *> *)limitNumbersOfLogFile {
    NSArray *files = [self allFiles];
    NSMutableArray *availableFileNames = [NSMutableArray array];
    NSDate *currentDate = [NSDate date];
    for (int i = 0; i  < files.count; i++) {
        NSString *todayFileName = [self fileNameWithDate:currentDate];
        if ([files[i] containsString:todayFileName]) continue;
        
        if ([files[i] hasSuffix:kDLLogFileSuffixLog] || [files[i] hasSuffix:kDLLogFileSuffixZip]) {
            [availableFileNames addObject:files[i]];
        }
    }
    // 删除超出最大数的文件
    while (availableFileNames.count >= self.maximumNumberOfLogFiles) {
        if ([DLFileHandler deleteFile:[self.logsDirectory stringByAppendingPathComponent:[availableFileNames firstObject]]]) {
            [availableFileNames removeObjectAtIndex:0];
        }
    }
    return availableFileNames;
}

/**
 *  检查是否有未归档的文件归档上传服务器
 *  @param files 文件名称数组
 *  @author sml
 */
- (void)uploadUnarchiveFileInLogFiles:(NSArray *)files {
    for (NSString *name in files) {
        if (![name hasSuffix:kDLLogFileSuffixLog]) continue;
        NSString *originFilePath = [self.logsDirectory stringByAppendingPathComponent:name];
        NSString *zipFilePath = [originFilePath stringByReplacingOccurrencesOfString:kDLLogFileSuffixLog withString:kDLLogFileSuffixZip];
        BOOL ok = [DLFileHandler createZipFileAtPath:zipFilePath withFilesAtPaths:@[originFilePath]];
        if (ok) {
            if ([DLLogManager sharedManager].uploadFileBlock) {
                [DLLogManager sharedManager].uploadFileBlock(zipFilePath,^(BOOL completed, NSError *error) {
                    if (completed) {
                        [DLFileHandler deleteFile:originFilePath];
                    } else {
                        [DLFileHandler deleteFile:zipFilePath];
                    }
                });
            } else {
                [DLFileHandler deleteFile:zipFilePath];
            }
        }
    }
}

- (void)stopTimer:(NSTimer *)timer {
    [timer invalidate];
    timer = nil;
}

/**
 *  将NSlog打印信息保存到指定文件中
 *
 *  @author sml
 */
- (void)redirectNSlogToFile:(NSString *)filePath {
    if (![DLLogManager sharedManager].redirectLogEnable) return;
    
    freopen([filePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([filePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

#pragma mark - setter and getter

- (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

- (NSArray *)allFiles {
    NSArray *paths = [DLFileHandler filesAtDirectory:self.logsDirectory isFullPath:NO];//取得文件列表
    NSArray *contents = [paths sortedArrayUsingComparator:^(NSString *firstPath, NSString*secondPath) {//
        
        NSString *name1 = [[firstPath stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"-" withString:@""];;
        NSString *name2 = [[secondPath stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        return ([@([name1 integerValue]) compare:@([name2 integerValue])]);//升序
    }];
    return contents;
}

- (NSString *)logsDirectory {
    if (![[NSFileManager defaultManager] fileExistsAtPath:_logsDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:_logsDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return _logsDirectory;
}

/**
 *  根据文件名跟后缀获取文件全路径
 *
 *  @author sml
 */
- (NSString *)fileFullPathWithFileName:(NSString *)fileName fileExtension:(NSString *)fileExtension {
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@",self.logsDirectory,fileName,fileExtension];
    if (![DLFileHandler existFile:filePath] && _onCreateFile == NO) {
        _onCreateFile = YES;
        [self willCreateLogFileAtPath:filePath];
        _onCreateFile = NO;
    }
    
    return filePath;
}

/**
 *  所有日志文件
 *
 *  @author sml
 */
- (NSArray<DLFileLoggerMessage *> *)logFiles {
    NSMutableArray *availableFiles = [NSMutableArray array];
    NSArray *files = [self allFiles];
    for (int i = 0; i  < files.count; i++) {
        if ([files[i] hasSuffix:kDLLogFileSuffixLog] || [files[i] hasSuffix:kDLLogFileSuffixZip]) {
            DLFileLoggerMessage *message = [[DLFileLoggerMessage alloc] initWithType:[files[i] hasSuffix:kDLLogFileSuffixLog] ? DLFileLoggerMessageTypeLog : DLFileLoggerMessageTypeZip fullPath:[self.logsDirectory stringByAppendingPathComponent:files[i]]];
            [availableFiles addObject:message];
        }
    }
    return availableFiles;
}

/**
 *  根据日期获取日志文件名称
 *
 *  @author sml
 */
- (NSString *)fileNameWithDate:(NSDate *)date {
    NSString *dateString = [self stringWithDate:date format:kDateFormatter];
    NSArray *array = [dateString componentsSeparatedByString:@" "];
    return [array firstObject];
}

@end
