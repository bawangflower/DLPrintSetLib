//
//  DLNetworkManager+ErrorHandler.h
//  Pods
//
//  Created by yjj on 2017/5/24.
//
//

#import <DLNetwork/DLNetworkManager.h>
#import "DLNetworkErrorHandler.h"

@interface DLNetworkManager (ErrorHandler)

/**
 begin a HTTP request
 
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithCompletionHandler:(DLNetworkSuccessBlock)completionHandler
                                                 option:(DLNetworkErrorHandlerOptions)option
                                         failureHandler:(DLNetworkFailureBlock)failureHandler;


/**
 Begin Data Task Request
 
 @param params
 @param httpBody
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params
                                    httpBody:(NSDictionary *)httpBody
                                      option:(DLNetworkErrorHandlerOptions)option
                           completionHandler:(DLNetworkSuccessBlock)completionHandler
                              failureHandler:(DLNetworkFailureBlock)failureHandler;

/**
 Begin Data Task Request
 
 @param params
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params
                                      option:(DLNetworkErrorHandlerOptions)option
                           completionHandler:(DLNetworkSuccessBlock)completionHandler
                              failureHandler:(DLNetworkFailureBlock)failureHandler;
/**
 sync Begin Data Task Request
 
 @param params
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)syncStartRequestWithParams:(NSDictionary *)params
                                          option:(DLNetworkErrorHandlerOptions)option
                               completionHandler:(DLNetworkSuccessBlock)completionHandler
                                  failureHandler:(DLNetworkFailureBlock)failureHandler;

/**
 Download File
 
 @param params
 @param filePath
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params downloadFilePath:(NSString *)filePath
                                      option:(DLNetworkErrorHandlerOptions)option
                           completionHandler:(DLNetworkSuccessBlock)completionHandler
                              failureHandler:(DLNetworkFailureBlock)failureHandler;

/**
 Upload Datas
 
 @param params
 @param uploadDatas
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params
                                 uploadDatas:(NSArray<DLUploadFormData *> *)uploadDatas
                                      option:(DLNetworkErrorHandlerOptions)option
                           completionHandler:(DLNetworkSuccessBlock)completionHandler
                              failureHandler:(DLNetworkFailureBlock)failureHandler;

@end
