//
//  DLNetworkConstant.h
//  PocketSLH
//
//  Created by GaoYuJian on 17/1/10.
//
//

#ifndef DLNetworkConstant_h
#define DLNetworkConstant_h

@class DLUploadFormData;

extern NSInteger const DLNetworkErrorCode;
extern NSString * const DLNetworkErrorDomain;

typedef NS_ENUM(NSUInteger, DLHTTPMethodType) {
    DLHTTPMethodGET = 0,
    DLHTTPMethodPOST = 1,
    DLHTTPMethodHEAD = 2,
    DLHTTPMethodDELETE = 3,
    DLHTTPMethodPUT = 4
};

typedef NS_ENUM(NSUInteger, DLRequestType) {
    DLRequestNormal = 0,
    DLRequestUpload = 1,
    DLRequestDownload = 2,
};

typedef NS_ENUM(NSUInteger, DLRequestSerializerType) {
    DLRequestSerializerRAW = 0,
    DLRequestSerializerJSON = 1
};

typedef NS_ENUM(NSUInteger, DLReponseSerializerType) {
    DLResponseSerializerRAW = 0,
    DLResponseSerializerJSON = 1,
    DLResponseSerializerXML = 2,
    DLResponseSerializerString = 3
};

typedef void (^DLNetworkFormDataBlock)(NSMutableArray<DLUploadFormData *> *uploadDatas);

typedef void (^DLNetworkSuccessBlock)(id responseObject);

typedef void (^DLNetworkFailureBlock)(NSError *error);

typedef void (^DLNetworkFinishedBlock)(id responseObject, NSError *error);

typedef NSDictionary * (^DLNetworkRequestProcessBlock)(NSDictionary *requestParams, NSDictionary *httpBody);

typedef void (^DLNetworkResponseProcessBlock)(NSURLResponse *response, id responseObject, NSError *__autoreleasing *error);

#endif /* DLNetworkConstant_h */
