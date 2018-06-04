//
//  DLNetworkManager.h
//  PocketSLH
//
//  Created by yunyu on 16/1/19.
//
//

#import <Foundation/Foundation.h>
#import "DLNetworkConfig.h"
#import "DLUploadFormData.h"

@interface DLNetworkManager : NSObject

/**
 单例对象配置网络请求相关属性
 */
@property (nonatomic, strong) DLNetworkConfig *config;

/**
 如果设置，则覆盖config中的generalServer和api
 */
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *api;

/**
 http header
 */
@property (nonatomic, copy) NSDictionary *headers;

@property (nonatomic, copy) NSDictionary *httpBody;

/**
 url query string
 */
@property (nonatomic, copy) NSDictionary *generalParams;

/**
 下载文件保存的路径
 */
@property (nonatomic, copy) NSString *downloadFilePath;

/**
 上传数据
 */
@property (nonatomic, copy) NSArray<DLUploadFormData *> *uploadDatas;

/**
 是否使用config中的generalParams
 */
@property (nonatomic, assign) BOOL useGeneralParams;

/**
 是否使用config中的generalHeaders
 */
@property (nonatomic, assign) BOOL useGeneralHeaders;

@property (nonatomic, assign) DLHTTPMethodType httpMethod;

@property (nonatomic, assign) DLRequestType requestType;

@property (nonatomic, assign) DLRequestSerializerType requestSerializerType;

@property (nonatomic, assign) DLReponseSerializerType reponseSerializerType;

/**
  请求超时时间，默认60s
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 请求完成时的回调队列默认为main queue
 */
@property (nonatomic, strong) dispatch_queue_t callbackQueue;

@property (nonatomic, strong, readonly) NSURLSessionTask *sessionTask;

#pragma mark - Lifecycle

- (instancetype)initWithParams:(NSDictionary *)params httpBody:(NSDictionary *)httpBody;

- (instancetype)initWithParams:(NSDictionary *)params downloadFilePath:(NSString *)filePath;

- (instancetype)initWithParams:(NSDictionary *)params uploadDatas:(NSArray<DLUploadFormData *> *)uploadDatas;

- (NSURLSessionTask *)startRequest;

/**
 begin a HTTP request
 
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithCompletionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler;


/**
 Begin Data Task Request
 
 @param params
 @param httpBody
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params httpBody:(NSDictionary *)httpBody completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler;

/**
 Begin Data Task Request

 @param params
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params  completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler;
/**
 sync Begin Data Task Request
 
 @param params
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)syncStartRequestWithParams:(NSDictionary *)params  completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler;

/**
 Download File
 
 @param params
 @param filePath
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params downloadFilePath:(NSString *)filePath completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler;

/**
 Upload Datas
 
 @param params
 @param uploadDatas
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params uploadDatas:(NSArray<DLUploadFormData *> *)uploadDatas completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler;

@end
