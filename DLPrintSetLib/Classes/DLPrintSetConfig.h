//
//  DLPrintSetConfig.h
//  AFNetworking
//
//  Created by LiYanQin on 2018/6/1.
//

#import <Foundation/Foundation.h>
#import "DLPrintProgramItem.h"

/**
 打印模式
 
 - DLPrintModelLocal: 本地打印
 - DLPrintModelRemote: 远程打印
 - DLPrintModelAll: 本地加远程打印
 */
typedef NS_ENUM(NSUInteger, DLPrintModelType) {
    DLPrintModelLocal = 0,
    DLPrintModelRemote = 1,
    DLPrintModelLocalAndRemote = 2,
};

typedef void(^DLPrintSetConfigOpenAutoPrintBlock)(BOOL openAutoPrint);

typedef void(^DLPrintSetConfigChangePrintModeBlock)(DLPrintModelType modelType);

typedef void(^DLPrintSetConfigSavePrintProgramInfoBlock)(DLPrintProgramItem *item);

typedef void(^DLPrintSetConfigPrintTestBlock)();

@interface DLPrintSetConfig : NSObject

+ (instancetype)sharedConfig;

/**
 打印模式
 */
@property (nonatomic, assign) DLPrintModelType modelType;

/**
 是否自动打印
 */
@property (nonatomic, assign) BOOL openAutoPrint;

@property (nonatomic, copy) NSString *salesPrintRemote;

@property (nonatomic, copy) NSString *clientDeviceNo;

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, strong) DLPrintProgramItem *programItem;

@property (nonatomic, copy) NSString *generalServer;

@property (nonatomic, copy) DLPrintSetConfigOpenAutoPrintBlock openAutoPrintBlock;

@property (nonatomic, copy) DLPrintSetConfigChangePrintModeBlock changePrintModeBlock;

@property (nonatomic, copy) DLPrintSetConfigSavePrintProgramInfoBlock savePrintProgramInfoBlock;

@property (nonatomic, copy) DLPrintSetConfigPrintTestBlock printTestBlock;

@end
