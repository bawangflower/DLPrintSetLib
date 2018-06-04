//
//  DLJSONSerializing.h
//  PocketSLH
//
//  Created by yunyu on 16/3/4.
//
//

#import <Foundation/Foundation.h>

@protocol DLJSONSerializing <NSObject>

@optional

+ (NSDictionary *)dl_JSONKeyPathsByPropertyKey;

+ (NSDictionary *)dl_objectClassInArray;

- (NSDictionary *)dl_JSONKeyPathsByPropertyKey;

- (NSDictionary *)dl_objectClassInArray;

@end
