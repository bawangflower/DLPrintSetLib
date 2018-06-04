//
//  DLPickerItemProtocol.h
//  Pods
//
//  Created by GaoYuJian on 2017/4/21.
//
//

#import <Foundation/Foundation.h>

@protocol DLPickerItemProtocol <NSObject>

@property (nonatomic, copy) NSString *text;

@optional

@property (nonatomic, copy) NSString *identifier;

@end
