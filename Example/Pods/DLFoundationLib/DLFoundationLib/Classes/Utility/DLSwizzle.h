//
//  DLSwizzle.h
//  PocketSLH
//
//  Created by yunyu on 16/5/27.
//
//

#import <Foundation/Foundation.h>

extern void DLSwizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector);
