//
//  DLPickerPopupView.h
//  Pods
//
//  Created by GaoYuJian on 2017/4/21.
//
//

@import DLPopupControl;
#import "DLPickerItemProtocol.h"

@class DLPickerPopupView;

typedef void (^DLPickerSelectedHandler)(DLPickerPopupView *pickerView, id<DLPickerItemProtocol>selectedItem);

@protocol DLPickerPopupViewDelegate <NSObject>

@optional

- (void)pickerView:(DLPickerPopupView *)pickerView  didSelectOneItem:(id <DLPickerItemProtocol>)item;

@end

@interface DLPickerPopupView : DLPopupView

@property (nonatomic, copy) DLPickerSelectedHandler selectedHandler;

@property (nonatomic, weak) id <DLPickerPopupViewDelegate> delegate;

/**
 上次选中的索引
 */
@property (nonatomic, assign) NSUInteger preSelectedIndex;

+ (instancetype)pickerPopupWithTitle:(NSString *)title items:(NSArray <id<DLPickerItemProtocol>> *)items;

@end
