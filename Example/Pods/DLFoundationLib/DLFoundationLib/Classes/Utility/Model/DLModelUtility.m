//
//  DLModelUtility.m
//  PocketSLH
//
//  Created by yunyu on 16/1/5.
//
//

#import "DLModelUtility.h"
#import "NSObject+DLJSONSerializing.h"
#import "DLAppMacro.h"
#import <objc/runtime.h>

@implementation DLModelUtility

/**
 *  将指定的字典内容映射到指定的对象中
 *
 *  @param object 指定的对象
 *  @param dict   指定的字典
 */
+ (void)convertObject:(id)object dict:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *jsonkeys;
    if ([object respondsToSelector:@selector(dl_JSONKeyPathsByPropertyKey)]) {
        jsonkeys = [object dl_JSONKeyPathsByPropertyKey];
    }else if ([[object class] respondsToSelector:@selector(dl_JSONKeyPathsByPropertyKey)]) {
        jsonkeys = [[object class] dl_JSONKeyPathsByPropertyKey];
    }
    
    NSDictionary *classkeysForArray;
    if ([object respondsToSelector:@selector(dl_objectClassInArray)]) {
        classkeysForArray = [object dl_objectClassInArray];
    }else if ([[object class] respondsToSelector:@selector(dl_objectClassInArray)]) {
        classkeysForArray = [[object class] dl_objectClassInArray];
    }
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id jsonkey = key;
        if (jsonkeys) {
            id tmpkey = jsonkeys[key];
            if (tmpkey) {
                jsonkey = tmpkey;
            }
        }
        
        objc_property_t property = class_getProperty([object class], [jsonkey UTF8String]);
        NSString *propertyAttrbutes;
        if (property) {
            propertyAttrbutes = [NSString stringWithUTF8String:property_getAttributes(property)];
            NSString *propertyType = [self typeWithPropertyAttrbutes:propertyAttrbutes];
            
            if ([obj isKindOfClass:[NSArray class]]) {
                // NSArray
                NSMutableArray *propertyArray = [@[] mutableCopy];
                id modelName = key;
                if (classkeysForArray) {
                    id tmpName = classkeysForArray[key];
                    if (tmpName) {
                        modelName = tmpName;
                    }
                }
                
                Class objectClass = NSClassFromString(modelName);
                if (objectClass) {
                    for (id item in (NSArray *)obj) {
                        id modelObject = [[objectClass alloc] init];
                        [self convertObject:modelObject dict:item];
                        [propertyArray addObject:modelObject];
                    }
                }else {
                    [propertyArray addObjectsFromArray:obj];
                }
                
                [object setValue:propertyArray forKey:jsonkey];
                
            }else if(propertyType && [NSStringFromClass([NSNumber class]) isEqualToString:propertyType]) {
                // NSNumber
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *value = [NSString stringWithFormat:@"%@", obj];
                if ([object respondsToSelector:NSSelectorFromString(jsonkey)]) {
                    [object setValue:[numberFormatter numberFromString:value] forKey:jsonkey];
                }
                
            }else {
                [object setValue:obj forKey:jsonkey];
            }
        }
    }];
}

+ (NSString *)typeWithPropertyAttrbutes:(NSString *)attrbutes {
    if (!attrbutes) {
        return nil;
    }
    
    NSString *pattern = @"\"\\w+\"";
    NSRegularExpression *rgex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:NULL];
    
    __block NSString *typeString;
    
    [rgex enumerateMatchesInString:attrbutes options:kNilOptions range:NSMakeRange(0, attrbutes.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange range = result.range;
        typeString = [attrbutes substringWithRange:NSMakeRange(range.location+1, range.length-2)];
        *stop = YES;
    }];
    
    return typeString;
}

/**
 *  将指定的对象转换为字典
 *
 *  @param object
 *
 *  @return
 */
+ (NSDictionary *)dictWithObject:(id)object {
    NSMutableDictionary *dict = [@{} mutableCopy];
    
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        id value = [object valueForKey:name];
        
        setupDictValue(dict, name, value);
    }
    
    free(propertyList);
    
    return dict.count > 0 ? [dict copy] : nil;
}

/**
 *  拷贝指定的对象
 *
 *  @param object
 *
 *  @return
 */
+ (id)objectWithObject:(id)object {
    id copyObject = [[[object class] alloc] init];
    
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        id value = [object valueForKey:name];
        [copyObject setValue:value forKey:name];
    }
    
    free(propertyList);
    
    return copyObject;
}

@end
