//
//  NSObject+DLJSONSerializing.m
//  PocketSLH
//
//  Created by yunyu on 16/3/4.
//
//

#import "NSObject+DLJSONSerializing.h"

@implementation NSObject (DLJSONSerializing)

+ (NSDictionary *)dl_JSONKeyPathsByPropertyKeyForSuper {
    id superObject = [self superclass];
    if (superObject && [superObject respondsToSelector:@selector(dl_JSONKeyPathsByPropertyKey)]) {
        return [superObject dl_JSONKeyPathsByPropertyKey];
    }
    
    return nil;
}

+ (NSDictionary *)dl_objectClassInArrayForSuper {
    id superObject = [self superclass];
    if (superObject && [superObject respondsToSelector:@selector(dl_objectClassInArray)]) {
        return [superObject dl_objectClassInArray];
    }
    
    return nil;
}

@end
