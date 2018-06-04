//
//  DLFileHandler.h
//  Pods
//
//  Created by sml2 on 17/2/14.
//
//

#import <Foundation/Foundation.h>

@interface DLFileHandler : NSObject

/**
 *  根据文件路径创建zip文件并返回zip文件路径
 *
 *  @author sml
 */
+ (NSString *)createZipFileWithFile:(NSString *)filePath;

/**
 *  指定路径创建zip文件
 *
 *  @author sml
 */
+ (BOOL)createZipFileAtPath:(NSString *)zipFilePath withFilesAtPaths:(NSArray *)paths;
/**
 *  解压文件
 *
 *  @author sml
 */
+ (BOOL)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination;
/**
 *  指定路径文件追加数据
 *
 *  @author sml
 */
+ (void)appendingToFile:(NSString *)fileFullPath content:(NSData *)content;
/**
 *  创建文件
 *
 *  @author sml
 */
+ (BOOL )createFile:(NSString *)filePath content:(NSData *)content;
/**
 *  删除指定文件
 *
 *  @author sml
 */
+ (BOOL )deleteFile:(NSString *)filePath;
/**
 *  文件是否存在
 *
 *  @author sml
 */
+ (BOOL )existFile:(NSString *)filePath;

/**
 *  获取directoryPath目录下子文件 isFullPath是否返回全路径
 *
 *  @author sml
 */
+ (NSArray<NSString *> *)filesAtDirectory:(NSString *)directoryPath isFullPath:(BOOL )isFullPath;
@end
