//
//  DLDatePickerView.h
//  Pods
//
//  Created by yjj on 2017/6/22.
//
//

#import <UIKit/UIKit.h>
#import "DLBlockType.h"
@class DLDatePickerView;

@protocol DLDatePickerViewDelegate <NSObject>

@optional

- (void)datePickerViewDidCancel:(DLDatePickerView *)datePickerView;

- (void)datePickerViewDidDone:(DLDatePickerView *)datePickerView;

- (void)datePickerValueChanged:(DLDatePickerView *)datePickerView;

@end

@interface DLDatePickerView : UIView

/**
 代理
 */
@property (nonatomic, weak) id<DLDatePickerViewDelegate> delegate;

/**
 日期发生改变的Block
 */
@property (nonatomic, copy) CompletionBlock dateChangeBlock;

/**
 日期选择器
 */
@property (nonatomic, strong, readonly) UIDatePicker *datePicker;

/**
 导航栏的字体和滚轮的字体颜色
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 绑定的时候需要
 */
@property (nonatomic, weak) UIView *callerView;

/**
 上次选择日期
 */
@property (nonatomic, copy) NSString *lastDateText;

@end

