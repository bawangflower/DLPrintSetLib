//
//  DLLogManager.m
//  PocketSLH
//
//  Created by sml2 on 17/2/5.
//
//

#import "DLLogManager.h"
#import "DLLogger.h"
#import "DLFileLogger.h"
#import "DLFileLoggerMessage.h"
#import "DLFileHandler.h"
#include <pthread.h>

@interface DLLogManager ()

@property (nonatomic, strong) NSMutableArray *loggers;

@property (nonatomic, strong) DLFileLogger *fileLogger;

@end
@implementation DLLogManager

static dispatch_queue_t _logQueue;

+ (instancetype)sharedManager {
    static DLLogManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _autoUploadEnable = NO;
        _logQueue = dispatch_queue_create("DLLogManager.logQueue", NULL);
    }
    return self;
}

#pragma mark - Public

- (void)start {
    [self.fileLogger configureLogger];
}

- (NSArray<DLFileLoggerMessage *> *)logFiles {
   return [self.fileLogger logFiles];
}

- (void)uploadLogFileWithMessage:(DLFileLoggerMessage *)message {
    [self uploadLogFileWithMessage:message completionHandler:nil];
}

- (void)uploadLogFileWithMessage:(DLFileLoggerMessage *)message completionHandler:(DLLogUploadFileCompleteCallback)completionHandler {
    if (self.uploadFileBlock) {
        if (![message.zipFilePath length]) {
            NSLog(@"日志文件路径为空!!!");
            return;
        }
        self.uploadFileBlock(message.zipFilePath,^(BOOL success, NSError *error) {
            if (message.type == DLFileLoggerMessageTypeLog) {
                [DLFileHandler deleteFile:message.zipFilePath];
            }
            if (completionHandler) {
                completionHandler(success, error);
            }
        });
    }
}

- (void)uploadTodayLogFileWithCompletionHandler:(DLLogUploadFileCompleteCallback)completionHandler {
    [self uploadLogFileForDate:[NSDate date] completionHandler:completionHandler];
}

- (void)uploadLogFileForDate:(NSDate *)date completionHandler:(DLLogUploadFileCompleteCallback)completionHandler {
    NSString *fileName = [self.fileLogger fileNameWithDate:date];
    __block DLFileLoggerMessage *logMessage;
    [self.fileLogger.logFiles enumerateObjectsUsingBlock:^(DLFileLoggerMessage *message, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([message.fullPath.lastPathComponent hasPrefix:fileName]) {
            logMessage = message;
            *stop = YES;
        }
    }];
    
    [self uploadLogFileWithMessage:logMessage completionHandler:completionHandler];
}

+ (void)logFile:(const char *)file
       function:(const char *)function
           line:(NSUInteger)line
         format:(NSString *)format, ... {
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self logMessage:message fileName:[NSString stringWithFormat:@"%s",file] functionName:[NSString stringWithFormat:@"%s",function] line:line];
        
        va_end(args);
    }
}

#pragma mark - Internal Helper

+ (void)logMessage:(NSString *)message
          fileName:(NSString *)fileName
      functionName:(NSString *)functionName
              line:(NSUInteger)line{
    [[self sharedManager] log:message fileName:[fileName lastPathComponent] functionName:functionName line:line];
}

- (void)log:(NSString *)message
   fileName:(NSString *)fileName
functionName:(NSString *)functionName
       line:(NSUInteger)line{
    for (DLLogger *logger in self.loggers) {
        __uint64_t threadid;
        pthread_threadid_np(pthread_self(), &threadid);
        NSString *thread = [NSString stringWithFormat:@"%@", @(threadid)];
        dispatch_async(_logQueue, ^{
            [logger log:message fileName:fileName functionName:functionName line:line thread:thread];
        });
    }
}

#pragma mark - Setter and Getter

- (void)setAutoUploadEnable:(BOOL)autoUploadEnable{
    _autoUploadEnable = autoUploadEnable;
    
    if (_autoUploadEnable) {
        [self.fileLogger uploadUnarchiveFiles];
    }
}

- (NSMutableArray *)loggers {
    if (!_loggers) {
        _loggers = [[NSMutableArray alloc] init];
        [_loggers addObject:self.fileLogger];
        
        if (!self.redirectLogEnable) {
            DLLogger *logger = [[DLLogger alloc] init];
            [_loggers addObject:logger];
        }
    }
    return _loggers;
}

- (DLFileLogger *)fileLogger {
    if (!_fileLogger) {
        _fileLogger = [[DLFileLogger alloc] init];
    }
    return _fileLogger;
}

@end
