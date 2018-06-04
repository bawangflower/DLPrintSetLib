//
//  DLFileHandler.m
//  Pods
//
//  Created by sml2 on 17/2/14.
//
//

#import "DLFileHandler.h"
#import "SSZipArchive.h"
#import "DLLogHeader.h"

@implementation DLFileHandler

/**
 *  根据文件路径创建zip文件并返回zip文件路径
 *
 *  @author sml
 */
+ (NSString *)createZipFileWithFile:(NSString *)filePath {
    NSString *zipFileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
    
    NSString *zipFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]  stringByAppendingPathComponent:[zipFileName stringByAppendingPathExtension:@"zip"]];
    BOOL success = NO;
    
    success = [SSZipArchive createZipFileAtPath:zipFilePath withFilesAtPaths:@[filePath]];
    
    return success ? zipFilePath : nil;
}
/**
 *  指定路径创建zip文件
 *
 *  @author sml
 */
+ (BOOL )createZipFileAtPath:(NSString *)zipFilePath withFilesAtPaths:(NSArray *)paths{
    return [SSZipArchive createZipFileAtPath:zipFilePath withFilesAtPaths:paths];
}
/**
 *  解压文件
 *
 *  @author sml
 */
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination {
    
    return [SSZipArchive unzipFileAtPath:path toDestination:destination];
}

/**
 *  指定路径文件追加数据
 *
 *  @author sml
 */
+ (void)appendingToFile:(NSString *)fileFullPath content:(NSData *)content {
    if (![self existFile:fileFullPath]) {
        DLLog(@"%@:路径不存在",fileFullPath);
        return;
    }
    NSFileHandle *updateFile = [NSFileHandle fileHandleForUpdatingAtPath:fileFullPath];
    [updateFile seekToEndOfFile];
    [updateFile writeData:content];
    [updateFile closeFile];
}

/**
 *  创建文件
 *
 *  @author sml
 */
+ (BOOL )createFile:(NSString *)filePath content:(NSData *)content {
    return [[NSFileManager defaultManager] createFileAtPath:filePath contents:content attributes:nil];
}

/**
 *  删除指定文件
 *
 *  @author sml
 */
+ (BOOL )deleteFile:(NSString *)filePath {
    DLLog(@"DLFileHandler.deleteFile:%@",filePath);
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

/**
 *  文件是否存在
 *
 *  @author sml
 */
+ (BOOL )existFile:(NSString *)filePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (NSArray<NSString *> *)filesAtDirectory:(NSString *)directoryPath isFullPath:(BOOL )isFullPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *directoryUrl = [[NSURL alloc] initFileURLWithPath:directoryPath isDirectory:YES];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:directoryUrl includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
        if (error) {
            DLLog(@"filesAtDirectory Error:%@ (%@)", error, url);
            return NO;
        }
        return YES;
    }];
    NSMutableArray *filePaths = [@[] mutableCopy];
    for (NSURL *fileUrl in enumerator) {
        NSString *fileName;
        [fileUrl getResourceValue:&fileName forKey:NSURLNameKey error:NULL];
        if ([fileName length]) {
            fileName = isFullPath ? [directoryPath stringByAppendingPathComponent:fileName] : fileName;
            [filePaths addObject:fileName];
        }
    }
    return filePaths;
}
@end
