//
//  DLPrintModel.h
//  StaffAssistant
//
//  Created by LiYanQin on 2018/4/4.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLPrintModel : NSObject

@property (nonatomic, strong) NSNumber *id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, strong) NSNumber *templateTypeId;

@property (nonatomic, strong) NSNumber *paperTypeId;

@property (nonatomic, strong) NSNumber *selected;

@property (nonatomic, strong) NSNumber *templateComFlag;

@end
