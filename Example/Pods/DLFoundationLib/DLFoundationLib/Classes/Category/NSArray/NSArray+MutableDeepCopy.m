//
//  NSMutableArray+MutableDeepCopy.m
//  PocketSLH
//
//  Created by yunyu on 15/9/6.
//
//

#import "NSArray+MutableDeepCopy.h"

@implementation NSArray (MutableDeepCopy)

- (NSMutableArray *)mutableDeepCopy {
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (id item in self) {
        if ([item respondsToSelector:@selector(mutableDeepCopy)]) {
            [resultArray addObject:[item mutableDeepCopy]];
        } else {
            [resultArray addObject:[item mutableCopy]];
        }
    }
    
    return resultArray;
}

@end
