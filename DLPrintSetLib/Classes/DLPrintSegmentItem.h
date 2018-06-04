//
//  DLPrintSegmentItem.h
//  StaffAssistant
//
//  Created by LiYanQin on 2018/5/28.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DLPrintTypeProgram,
    DLPrintTypeCloud
} DLPrintType;

typedef enum : NSUInteger {
    DLPrintChannelIdLocal,
    DLPrintChannelIdRemote,
    DLPrintChannelIdBarcode,
    DLPrintChannelIdDoc
} DLPrintChannelId;

@interface DLPrintSegmentItem : NSObject

@property (nonatomic, assign) DLPrintType printType;

//云打印 打印渠道 1：单据本地，2：单据远程 3：条码打印 4：面单打印

@property (nonatomic, assign) DLPrintChannelId printChannelId;

@end
