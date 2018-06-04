//
//  DLNetworkManager+ErrorHandler.m
//  Pods
//
//  Created by yjj on 2017/5/24.
//
//

#import "DLNetworkManager+ErrorHandler.h"
#import "DLNetworkErrorHandler.h"

@implementation DLNetworkManager (ErrorHandler)

/**
 begin a HTTP request
 
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithCompletionHandler:(DLNetworkSuccessBlock)completionHandler
                                                 option:(DLNetworkErrorHandlerOptions)option
                                         failureHandler:(DLNetworkFailureBlock)failureHandler {
    return [self startRequestWithCompletionHandler:completionHandler failureHandler:^(NSError *error) {
        [[DLNetworkErrorHandler defaultHandler] dealNetworkError:error option:option];
        failureHandler(error);
    }];
}


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
                              failureHandler:(DLNetworkFailureBlock)failureHandler {
    return [self startRequestWithParams:params httpBody:httpBody completionHandler:completionHandler failureHandler:^(NSError *error) {
        [[DLNetworkErrorHandler defaultHandler] dealNetworkError:error option:option];
        failureHandler(error);
    }];
}

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
                              failureHandler:(DLNetworkFailureBlock)failureHandler {
    return [self startRequestWithParams:params completionHandler:completionHandler failureHandler:^(NSError *error) {
        [[DLNetworkErrorHandler defaultHandler] dealNetworkError:error option:option];
        failureHandler(error);
    }];
}
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
                                  failureHandler:(DLNetworkFailureBlock)failureHandler {
    return [self syncStartRequestWithParams:params completionHandler:completionHandler failureHandler:^(NSError *error) {
        [[DLNetworkErrorHandler defaultHandler] dealNetworkError:error option:option];
        failureHandler(error);
    }];
}

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
                              failureHandler:(DLNetworkFailureBlock)failureHandler {
    return [self startRequestWithParams:params downloadFilePath:filePath completionHandler:completionHandler failureHandler:^(NSError *error) {
        [[DLNetworkErrorHandler defaultHandler] dealNetworkError:error option:option];
        failureHandler(error);
    }];
}

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
                              failureHandler:(DLNetworkFailureBlock)failureHandler {
    return [self startRequestWithParams:params uploadDatas:uploadDatas completionHandler:completionHandler failureHandler:^(NSError *error) {
        [[DLNetworkErrorHandler defaultHandler] dealNetworkError:error option:option];
        failureHandler(error);
    }];
}

@end
