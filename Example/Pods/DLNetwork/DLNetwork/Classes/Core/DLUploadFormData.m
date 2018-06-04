//
//  DLUploadFormData.m
//  PocketSLH
//
//  Created by GaoYuJian on 17/1/12.
//
//

#import "DLUploadFormData.h"
#import "DLAppMacro.h"

@implementation DLUploadFormData

+ (instancetype)formDataWithName:(NSString *)name fileData:(NSData *)fileData {
    DLUploadFormData *formData = [[DLUploadFormData alloc] init];
    formData.name = name;
    formData.fileData = fileData;
    return formData;
}

+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData {
    DLUploadFormData *formData = [[DLUploadFormData alloc] init];
    formData.name = name;
    formData.fileName = fileName;
    formData.mimeType = mimeType;
    formData.fileData = fileData;
    return formData;
}

+ (instancetype)formDataWithName:(NSString *)name fileURL:(NSURL *)fileURL {
    DLUploadFormData *formData = [[DLUploadFormData alloc] init];
    formData.name = name;
    formData.fileURL = fileURL;
    return formData;
}

+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL {
    DLUploadFormData *formData = [[DLUploadFormData alloc] init];
    formData.name = name;
    formData.fileName = fileName;
    formData.mimeType = mimeType;
    formData.fileURL = fileURL;
    return formData;
}

- (NSString *)description {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    setupDictValue(info, @"name", self.name);
    setupDictValue(info, @"filename", self.fileName);
    setupDictValue(info, @"mimeType", self.mimeType);
    setupDictValue(info, @"fileDataLength", @(self.fileData.length));
    setupDictValue(info, @"fileURL", self.fileURL);
    return [info description];
}

@end
