//
//  DLNetworkManager.m
//  PocketSLH
//
//  Created by yunyu on 16/1/19.
//
//

#import "DLNetworkManager.h"
#import "AFNetworking.h"
#import "DLLogHeader.h"
#import "DLNetrowkMessage.h"

NSInteger const DLNetworkErrorCode = 888888;
NSString * const DLNetworkErrorDomain = @"DLNetworkErrorDomain";

static NSString *const DLNetworkDataFormatError = @"数据格式错误";
static NSString *const DLNetworkErrorDataKey = @"DLNetworkErrorDataKey";

@interface DLNetworkManager () 

/**
 url query string
 */
@property (nonatomic, copy) NSDictionary *params;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong, readwrite) NSURLSessionTask *sessionTask;

@end

@implementation DLNetworkManager

#pragma mark - Life cycle

- (void)dealloc {
    [_sessionManager invalidateSessionCancelingTasks:YES];
}

- (instancetype)initWithParam:(NSDictionary *)params httpBody:(NSDictionary *)httpBody downloadFilePath:(NSString *)filePath uploadDatas:(NSArray<DLUploadFormData *> *)uploadDatas {
    self = [super init];
    if (self) {
        self.params = params;
        self.httpBody = httpBody;
        self.downloadFilePath = filePath;
        self.uploadDatas = uploadDatas;
        self.useGeneralParams = YES;
        self.useGeneralHeaders = YES;
        self.httpMethod = DLHTTPMethodPOST;
        self.requestType = DLRequestNormal;
        self.timeoutInterval = 60;
        self.reponseSerializerType = DLResponseSerializerJSON;
        self.config = [DLNetworkConfig sharedConfig];
    }
    return self;
}

- (instancetype)initWithParams:(NSDictionary *)params httpBody:(NSDictionary *)httpBody  {
    return [self initWithParam:params httpBody:httpBody downloadFilePath:nil uploadDatas:nil];
}

- (instancetype)initWithParams:(NSDictionary *)params {
    return [self initWithParam:params httpBody:nil downloadFilePath:nil uploadDatas:nil];
}

- (instancetype)initWithParams:(NSDictionary *)params downloadFilePath:(NSString *)filePath {
    return [self initWithParam:params httpBody:nil downloadFilePath:filePath uploadDatas:nil];
}

- (instancetype)initWithParams:(NSDictionary *)params uploadDatas:(NSArray<DLUploadFormData *> *)uploadDatas {
    return [self initWithParam:params httpBody:nil downloadFilePath:nil uploadDatas:uploadDatas];
}

- (instancetype)init {
    return [self initWithParam:nil httpBody:nil downloadFilePath:nil uploadDatas:nil];
}

#pragma mark - Public

/**
 begin a HTTP request

 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithCompletionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    return [self startRequestWithCompletionHandler:completionHandler failureHandler:failureHandler isSync:NO];
}

/**
 sync begin a HTTP request
 
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)syncStartRequestWithCompletionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler{
    return [self startRequestWithCompletionHandler:completionHandler failureHandler:failureHandler isSync:YES];
}

/**
 begin a HTTP request
 
 @param completionHandler
 @param failureHandler
 @param isSync 是否同步
 @return
 */
- (NSURLSessionTask *)startRequestWithCompletionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler isSync:(BOOL)isSync {
    if (isSync == YES) {
        self.callbackQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    } else {
        self.callbackQueue = nil;
    }
    __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    DLNetworkSuccessBlock successBlock = ^(id responseObject) {
        if (completionHandler) {
            completionHandler(responseObject);
        }
        dispatch_semaphore_signal(sem);
    };
    DLNetworkFailureBlock failureBlock = ^(NSError *error) {
        if (failureHandler) {
            failureHandler(error);
        }
        dispatch_semaphore_signal(sem);
    };
    NSURLSessionTask *sessionTask;
    switch (self.requestType) {
        case DLRequestNormal:
        {
            sessionTask = [self dataTaskWithParams:self.params httpBody:self.httpBody completionHandler:successBlock failureHandler:failureBlock];
        }
            
            break;
            
        case DLRequestUpload:
        {
            sessionTask = [self uploadTaskWithParams:self.params appendFormData:^(NSMutableArray<DLUploadFormData *> *uploadDatas) {
                [uploadDatas addObjectsFromArray:self.uploadDatas];
            } completionHandler:successBlock failureHandler:failureBlock];
        }
            
            break;
            
        case DLRequestDownload:
        {
            sessionTask = [self downloadTaskWithParams:self.params filePath:self.downloadFilePath completionHandler:successBlock failureHandler:failureBlock];
        }
            
            break;
    }
    [sessionTask resume];
    self.sessionTask = sessionTask;
    
    if (isSync == YES) {
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    }
    
    return sessionTask;
}

- (NSURLSessionTask *)startRequest {
    return [self startRequestWithCompletionHandler:nil failureHandler:nil];
}

/**
 Begin Data Task Request

 @param params
 @param httpBody
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params httpBody:(NSDictionary *)httpBody completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    self.params = params;
    self.httpBody = httpBody;
    self.requestType = DLRequestNormal;
    return [self startRequestWithCompletionHandler:completionHandler failureHandler:failureHandler];
}

/**
 Begin Data Task Request
 
 @param params
 @param httpBody
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)syncStartRequestWithParams:(NSDictionary *)params httpBody:(NSDictionary *)httpBody completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    self.params = params;
    self.httpBody = httpBody;
    self.requestType = DLRequestNormal;
    return [self startRequestWithCompletionHandler:completionHandler failureHandler:failureHandler isSync:YES];
}

- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params  completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    return [self startRequestWithParams:params httpBody:nil completionHandler:completionHandler failureHandler:failureHandler];
}

- (NSURLSessionTask *)syncStartRequestWithParams:(NSDictionary *)params  completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    return [self syncStartRequestWithParams:params httpBody:nil completionHandler:completionHandler failureHandler:failureHandler];
}

/**
 Download File

 @param params
 @param filePath
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params downloadFilePath:(NSString *)filePath completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    self.params = params;
    self.downloadFilePath = filePath;
    self.requestType = DLRequestDownload;
    return [self startRequestWithCompletionHandler:completionHandler failureHandler:failureHandler];
}

/**
 Upload Datas

 @param params
 @param uploadDatas
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)startRequestWithParams:(NSDictionary *)params uploadDatas:(NSArray<DLUploadFormData *> *)uploadDatas completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    self.params = params;
    self.uploadDatas = uploadDatas;
    self.requestType = DLRequestUpload;
    return [self startRequestWithCompletionHandler:completionHandler failureHandler:failureHandler];
}

#pragma mark - Private

/**
 fetchData

 @param params
 @param httpBody
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)dataTaskWithParams:(NSDictionary *)params httpBody:(NSDictionary *)httpBody completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    // url
    NSString *url = [self urlString];

    // params
    NSDictionary *requestParams = [self requestParams:params];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializer];
    NSError *serializationError;
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:[self getHttpMethod] URLString:url parameters:requestParams error:&serializationError];
    if (serializationError) {
        if (failureHandler) {
            dispatch_async(self.callbackQueue, ^{
                failureHandler(serializationError);
            });
        }
        return nil;
    }
    
    urlRequest.timeoutInterval = self.timeoutInterval;
    
    // httpHeaders;
    [self setHttpHeadersWithUrlRequest:urlRequest];
    
    if (self.config.consoleRequestLog) {
        DLLog(@"requestURL : %@\nrequestParams : %@", url, requestParams);
    }
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:urlRequest  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf processResponse:response object:responseObject error:error completionHandler:completionHandler failureHandler:failureHandler];
    }];
    
    return dataTask;
}

- (void)processResponse:(NSURLResponse *)response object:(id)responseObject error:(NSError *)error completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    if (self.reponseSerializerType == DLResponseSerializerString && [responseObject isKindOfClass:[NSData class]]) {
        responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    }
    
    if (error.code == 3840 && error.userInfo[NSUnderlyingErrorKey]) {
        NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:underlyingError.userInfo];
        NSData *data = userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if ([data isKindOfClass:[NSData class]]) {
            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (dataStr.length) {
                userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = dataStr;
            }
        }
        error = [NSError errorWithDomain:underlyingError.domain code:underlyingError.code userInfo:userInfo];
    }
    
    // 如果错误是关于Host找不到相关
    if (error.code == NSURLErrorCannotFindHost || error.code == NSURLErrorCannotConnectToHost) {
        error = [NSError errorWithDomain:DLNetworkErrorDomain code:error.code userInfo:@{ NSLocalizedDescriptionKey : [DLNetrowkMessage urlErorrMessageWithCode:error.code] }];
    }
    
    if (self.config.responseProcessHandler) {
        self.config.responseProcessHandler(response, responseObject, &error);
    }
    
    if (error) {
        DLLog(@"response : %@\nresponseError : %@", response, error);
    } else if (self.config.consoleResponseLog) {
        DLLog(@"response : %@\nresponseObject : %@", response, responseObject);
    }
    
    if (error) {
        if (failureHandler) {
            failureHandler(error);
        }
    } else {
        if (completionHandler) {
            completionHandler(responseObject);
        }
    }
}

/**
 upload datas

 @param params
 @param appendFormData append mutiform data
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)uploadTaskWithParams:(NSDictionary *)params appendFormData:(DLNetworkFormDataBlock)appendFormData completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    // url
    NSString *url = [self urlString];
    
    // params
    NSDictionary *requestParams = [self requestParams:params];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializer];
    
    __block NSError *serializationError;
    // append upload datas
    NSMutableArray<DLUploadFormData *> *uploadDatas = [NSMutableArray array];
    if (appendFormData) {
        appendFormData(uploadDatas);
    }
    NSMutableURLRequest *urlRequest = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:requestParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [uploadDatas enumerateObjectsUsingBlock:^(DLUploadFormData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.fileData) {
                if (obj.fileName && obj.mimeType) {
                    [formData appendPartWithFileData:obj.fileData name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
                } else {
                    [formData appendPartWithFormData:obj.fileData name:obj.name];
                }
            } else if (obj.fileURL) {
                NSError *fileError = nil;
                if (obj.fileName && obj.mimeType) {
                    [formData appendPartWithFileURL:obj.fileURL name:obj.name fileName:obj.fileName mimeType:obj.mimeType error:&fileError];
                } else {
                    [formData appendPartWithFileURL:obj.fileURL name:obj.name error:&fileError];
                }
                if (fileError) {
                    serializationError = fileError;
                    *stop = YES;
                }
            }
        }];
    } error:&serializationError];
    if (serializationError) {
        if (failureHandler) {
            dispatch_async(self.callbackQueue, ^{
                failureHandler(serializationError);
            });
        }
        return nil;
    }
    
    // httpHeaders;
    [self setHttpHeadersWithUrlRequest:urlRequest];
    
    if (self.config.consoleRequestLog) {
        DLLog(@"requestURL : %@\nrequestParams : %@\nuploadDatas:%@", url, requestParams, self.uploadDatas);
    }
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionUploadTask *uploadTask = [self.sessionManager uploadTaskWithStreamedRequest:urlRequest progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf processResponse:response object:responseObject error:error completionHandler:completionHandler failureHandler:failureHandler];
    }];
    
    return uploadTask;
}

/**
 download file

 @param params
 @param filePath
 @param completionHandler
 @param failureHandler
 @return
 */
- (NSURLSessionTask *)downloadTaskWithParams:(NSDictionary *)params filePath:(NSString *)filePath completionHandler:(DLNetworkSuccessBlock)completionHandler failureHandler:(DLNetworkFailureBlock)failureHandler {
    // url
    NSString *url = [self urlString];
    
    // params
    NSDictionary *requestParams = [self requestParams:params];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializer];
    
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:@"GET" URLString:url parameters:requestParams error:NULL];
    [self setHttpHeadersWithUrlRequest:urlRequest];
    
    NSURL *downloadFilePath = [NSURL fileURLWithPath:filePath];
    
    if (self.config.consoleRequestLog) {
        DLLog(@"requestURL : %@\nrequestParams : %@\nfilePath:%@", url, requestParams, filePath);
    }
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:urlRequest progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 移除历史文件
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ([httpResponse statusCode] == 200) {
            // delete existing file
            [[NSFileManager defaultManager] removeItemAtURL:downloadFilePath error:nil];
        }
        
        return downloadFilePath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (strongSelf.config.responseProcessHandler) {
            strongSelf.config.responseProcessHandler(response, filePath, &error);
        }
        
        if (error) {
            DLLog(@"responseError : %@", error);
        } else if (self.config.consoleResponseLog) {
            DLLog(@"response : %@\nfilePath : %@", response, filePath);
        }
        
        if (error) {
            if (failureHandler) {
                failureHandler(error);
            }
        } else {
            if (completionHandler) {
                completionHandler(filePath);
            }
        }
    }];
    
    return downloadTask;
}

#pragma mark - Setter And Getter

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [self responseSerializer];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
        _sessionManager.completionQueue = self.callbackQueue;
    }
    return _sessionManager;
}

- (dispatch_queue_t)callbackQueue {
    if (!_callbackQueue) {
        _callbackQueue = dispatch_get_main_queue();
    }
    return _callbackQueue;
}

- (void)setGeneralParams:(NSDictionary *)generalParams {
    NSMutableDictionary *requestParams = [[NSMutableDictionary alloc] initWithDictionary:_generalParams];
    [requestParams addEntriesFromDictionary:generalParams];
    _generalParams = [requestParams copy];
}

#pragma mark - Internal Helpers

- (NSString *)urlString {
    NSString *url;
    if (self.url.length) {
        url = self.url;
    } else {
        url = self.config.generalServer;
        if (self.api.length) {
            url = [url stringByAppendingFormat:@"/%@", self.api];
        }
    }
    return url;
}

- (NSString *)getHttpMethod {
    NSArray *httpMethodArray = @[@"GET", @"POST", @"HEAD", @"DELETE", @"PUT", @"PATCH"];
    NSString *httpMethod = httpMethodArray[_httpMethod];
    NSAssert(httpMethod.length > 0, @"The HTTP method not found.");
    return httpMethod;
}

- (NSDictionary *)requestParams:(NSDictionary *)params {
    // params
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionary];
    [requestParams addEntriesFromDictionary:_generalParams];
    [requestParams addEntriesFromDictionary:params];
    if (self.useGeneralParams) {
        [requestParams addEntriesFromDictionary:self.config.generalParams];
    }
    if (self.config.requestProcessHandler) {
        requestParams = [self.config.requestProcessHandler(requestParams, self.httpBody) mutableCopy];
    }
    return requestParams;
}

- (void)setHttpHeadersWithUrlRequest:(NSMutableURLRequest *)urlRequest {
    NSMutableDictionary *httpHeaders = [[NSMutableDictionary alloc] initWithDictionary:self.headers];
    if (self.useGeneralHeaders) {
        [httpHeaders addEntriesFromDictionary:self.config.generalHeaders];
    }
    if (httpHeaders.count) {
        [httpHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [urlRequest setValue:obj forHTTPHeaderField:key];
        }];
    }
}

- (AFHTTPRequestSerializer *)requestSerializer {
    switch (self.requestSerializerType) {
        case DLRequestSerializerRAW:
            return [AFHTTPRequestSerializer serializer];
            break;
            
        case DLRequestSerializerJSON:
            return [AFJSONRequestSerializer serializer];
            break;
    }
}

- (AFHTTPResponseSerializer *)responseSerializer {
    AFHTTPResponseSerializer *responseSerializer;
    switch (self.reponseSerializerType) {
        case DLResponseSerializerRAW:
            responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case DLResponseSerializerJSON:
        {
            responseSerializer = [AFJSONResponseSerializer serializer];
            ((AFJSONResponseSerializer *)responseSerializer).removesKeysWithNullValues = YES;
            NSMutableSet *types = [NSMutableSet setWithSet:responseSerializer.acceptableContentTypes];
            [types addObject:@"text/plain"];
            [types addObject:@"text/html"];
            responseSerializer.acceptableContentTypes = types;
        }
            break;
        case DLResponseSerializerXML:
            responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case DLResponseSerializerString:
            responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return responseSerializer;
}

@end
