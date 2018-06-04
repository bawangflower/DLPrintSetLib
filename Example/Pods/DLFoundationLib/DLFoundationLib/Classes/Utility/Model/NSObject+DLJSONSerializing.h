//
//  NSObject+DLJSONSerializing.h
//  PocketSLH
//
//  Created by yunyu on 16/3/4.
//
//

#import <Foundation/Foundation.h>
#import "DLJSONSerializing.h"

@interface NSObject (DLJSONSerializing) <DLJSONSerializing>

+ (NSDictionary *)dl_JSONKeyPathsByPropertyKeyForSuper;

+ (NSDictionary *)dl_objectClassInArrayForSuper;

@end
