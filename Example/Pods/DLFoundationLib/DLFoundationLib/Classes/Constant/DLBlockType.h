//
//  DLBlockType.h
//  PocketSLH
//
//  Created by yunyu on 16/4/28.
//
//

#ifndef DLBlockType_h
#define DLBlockType_h

typedef void (^EventBlock)();

typedef void (^CallBackBlock)();

typedef void (^CompletionBlock)(id responseObject);

typedef void (^FailureBlock)(NSError *error);

#endif /* DLBlockType_h */
