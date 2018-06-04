//
//  DLUploadImageManager.h
//  Pods
//
//  Created by yjj on 2017/5/19.
//
//

#import <UIKit/UIKit.h>
#import "DLNetworkManager.h"

typedef NS_ENUM(NSUInteger, DLImageType) {
    DLImagePNGType,
    DLImageJPGType,
};

/**
 多图上传图片信息容器
 */
@interface DLUploadMutilImageItem : NSObject

/**
 当前上传的图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 当前上传的索引
 */
@property (nonatomic, assign) NSUInteger index;

/**
 上传失败的错误信息
 */
@property (nonatomic, strong) NSError *error;

/**
 上传成功获取得到的fileId
 */
@property (nonatomic, copy) NSString *fileId;

/**
 重传的次数
 */
@property (nonatomic, assign) int repeatCount;

@end

@interface DLUploadImageManager : DLNetworkManager

/**
    资源服务器地址
 */
@property (nonatomic, copy, readonly) NSString *sourceServer;

/**
 图片可以重复上传的次数 默认 uploadRepeatCount = 2
 */
@property (nonatomic, assign) int uploadRepeatCount;

#pragma mark - init


/**
 初始化图片上传管理者

 @param sourceServer 图片上传的服务器地址 在sourceserver为nil的时候 取[[DLNetworkConfig sharedConfig] sourceServer]
 @return instance
 */
- (instancetype)initWithSourceServer:(NSString *)sourceServer;

#pragma mark - upload

/**
 上传单张图片

 @param image 图片
 @param imageType 上传的图片的格式
 @param successHandler  成功
 @param failureHandler  失败
 */
- (void)uploadImage:(UIImage *)image imageType:(DLImageType)imageType success:(DLNetworkSuccessBlock)successHandler failure:(DLNetworkFailureBlock)failureHandler;


/**
 多图上传
 
 @param images 图片的数组
 @param compelete 完成时候的回调
 */
- (void)uploadImages:(NSArray<UIImage *> *)images compelete:(void (^)(NSArray<DLUploadMutilImageItem *> *imageItems))compelete;

@end
