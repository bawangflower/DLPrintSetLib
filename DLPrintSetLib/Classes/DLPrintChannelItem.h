//
//  DLPrintChannelItem.h
//  Pods-DLPrintSetLib_Example
//
//  Created by LiYanQin on 2018/6/1.
//

#import <Foundation/Foundation.h>

@class DLPrintSegmentItem;

@interface DLPrintChannelItem : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSArray <DLPrintSegmentItem *> *connectTypes;
@end

