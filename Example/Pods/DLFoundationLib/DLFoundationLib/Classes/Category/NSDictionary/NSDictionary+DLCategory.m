//
//  NSDictionary+DLCategory.m
//  PocketSLH
//
//  Created by yunyu on 16/3/4.
//
//

#import "NSDictionary+DLCategory.h"

@implementation NSDictionary (DLCategory)

- (NSDictionary *)dl_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary {
    if (!dictionary) {
        return self;
    }
    
    NSMutableDictionary *result = [self mutableCopy];
    [result addEntriesFromDictionary:dictionary];
    return result;
}

@end
