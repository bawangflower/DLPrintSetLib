//
//  DLFileLoggerMessage.m
//  PocketSLH
//
//  Created by sml2 on 17/2/5.
//
//

#import "DLFileLoggerMessage.h"
#import "DLFileHandler.h"

NSString *const kDLLogFileSuffixLog = @".log";

NSString *const kDLLogFileSuffixZip = @".zip";

@interface DLFileLoggerMessage ()

@property (nonatomic, assign) DLFileLoggerMessageType type;

@property (nonatomic, copy) NSString *fullPath;

@property (nonatomic, copy) NSString *zipFilePath;

@end
@implementation DLFileLoggerMessage

- (instancetype)initWithType:(DLFileLoggerMessageType )type fullPath:(NSString *)fullPath {
    if (self = [super init]) {
        _type = type;
        _fullPath = fullPath;
    }
    return self;
}

- (NSString *)zipFilePath {
    if (!_zipFilePath) {
        _zipFilePath = _fullPath;
        if (_type != DLFileLoggerMessageTypeZip) {
            // 将原路径.log后缀改为.zip,即文件的压缩路径
            _zipFilePath = [_fullPath stringByReplacingOccurrencesOfString:kDLLogFileSuffixLog withString:kDLLogFileSuffixZip];
             [DLFileHandler createZipFileAtPath:_zipFilePath withFilesAtPaths:@[_fullPath]];
        }
    }
    return _zipFilePath;
}

@end
