//
//  DLUploadImageManager.m
//  Pods
//
//  Created by yjj on 2017/5/19.
//
//

#import "DLUploadImageManager.h"
#import <DLFoundationLib/UIImage+DLUtility.h>
#import <DLFoundationLib/DLBlockType.h>
#import "DLNetworkConfig.h"

@implementation DLUploadMutilImageItem
@end

@interface DLUploadImageManager ()

/**
 资源服务器地址
 */
@property (nonatomic, copy, readwrite) NSString *sourceServer;

@end

@implementation DLUploadImageManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.uploadRepeatCount = 2;
        self.url = [[[DLNetworkConfig sharedConfig] sourceServer] stringByAppendingPathComponent: @"slh/uploadMultiFile.do"];
        self.reponseSerializerType = DLResponseSerializerString;
    }
    return self;
}

- (instancetype)initWithSourceServer:(NSString *)sourceServer {
    if (self = [super init]) {
        if (sourceServer) {
            self.sourceServer = sourceServer ?: [[DLNetworkConfig sharedConfig] sourceServer];
            self.url = [self.sourceServer stringByAppendingPathComponent:@"slh/uploadMultiFile.do"];
        }
    }
    return self;
}

- (void)uploadImage:(UIImage *)image imageType:(DLImageType)imageType success:(DLNetworkSuccessBlock)successHandler failure:(DLNetworkFailureBlock)failureHandler {
    NSData *imageData;
    NSString *filename;
    NSString *mimeType;
    switch (imageType) {
            case DLImagePNGType: {
                imageData = UIImagePNGRepresentation(image);
                filename = @"image.png";
                mimeType = @"image/png";
                break;
            }
            case DLImageJPGType: {
                imageData = UIImageJPEGRepresentation(image, 0.5);
                filename = @"image.jpg";
                mimeType = @"image/jpg";
                break;
            }
    }
    DLUploadFormData *data = [DLUploadFormData formDataWithName:@"image" fileName:filename mimeType:mimeType fileData:imageData];
    [self startRequestWithParams:nil uploadDatas:@[data] completionHandler:^(id responseObject) {
        // 处理可能会出现的异常情况
        if (responseObject && [responseObject isKindOfClass:[NSString class]]) {
            NSData *data = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            id JSON  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                if ([responseObject length] > 0) {
                    successHandler(responseObject);
                }else {
                    failureHandler(error);
                }
            }else {
                successHandler(JSON);
            }
        }else {
            if (failureHandler) {
                failureHandler(nil);
            }
        }
    } failureHandler:failureHandler];
}

/**
 多图上传
 
 @param images 图片的数组
 @param compelete 完成时候的回调
 */
- (void)uploadImages:(NSArray<UIImage *> *)images compelete:(void (^)(NSArray<DLUploadMutilImageItem *> *imageItems))compelete {
    NSMutableArray *resultArray = [NSMutableArray array];
    dispatch_group_t uploadGroup = dispatch_group_create();
    for (int i = 0; i < images.count; i ++) {
        UIImage *image = images[i];
        dispatch_group_enter(uploadGroup);
        DLUploadMutilImageItem *item = [[DLUploadMutilImageItem alloc] init];
        item.image = image;
        item.index = i;
        [self uploadImageWithMutilItem:item handler:^(id responseObject) {
            [resultArray addObject:responseObject];
            dispatch_group_leave(uploadGroup);
        }];
    }
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        // 排序
        [resultArray sortUsingComparator:^NSComparisonResult(DLUploadMutilImageItem *obj1, DLUploadMutilImageItem *obj2) {
            return obj1.index > obj2.index;
        }];
        
        compelete(resultArray);
    });
}

/**
 上传一张图片  默认可以重复上传2次
 
 @param item 图片相关的数据
 @param handler 图片上传结束的回调
 */
- (void)uploadImageWithMutilItem:(DLUploadMutilImageItem *)item handler:(CompletionBlock)handler {
    [self uploadImage:item.image imageType:DLImageJPGType success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) { // 上传失败
            NSError *error = [NSError errorWithDomain:DLNetworkErrorDomain code:[responseObject[@"code"] integerValue] userInfo:@{ @"name" : responseObject[@"error"] }];
            item.error = error;
            if (item.repeatCount < self.uploadRepeatCount) { // 在上传失败的时候重新上传
                item.repeatCount ++;
                [self uploadImageWithMutilItem:item handler:handler];
            }else {
                handler(item);
            }
        }else {
            item.fileId = responseObject;
            item.error  = nil;
            handler(item);
        }
    } failure:^(NSError *error) {
        item.error = error;
        if (item.repeatCount < self.uploadRepeatCount) { // 在上传失败的时候重新上传
            item.repeatCount ++;
            [self uploadImageWithMutilItem:item handler:handler];
        }else {
            handler(item);
        }
    }];
}

@end
