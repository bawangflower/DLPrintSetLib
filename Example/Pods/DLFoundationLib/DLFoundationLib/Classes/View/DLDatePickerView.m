//
//  DLDatePickerView.m
//  Pods
//
//  Created by yjj on 2017/6/22.
//
//

#import "DLDatePickerView.h"
@import Colours;
@import Masonry;

static CGFloat const KToolBarHeight = 44;

#define DoneTitle NSLocalizedString(@"完成", nil)
#define CancelTitle NSLocalizedString(@"取消", nil)

@interface DLDatePickerView ()

/**
 显示确定和取消按钮
 */
@property (nonatomic, strong) UIToolbar *toolBar;

/**
 日期选择器
 */
@property (nonatomic, strong, readwrite) UIDatePicker *datePicker;

@end

@implementation DLDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.toolBar];
    [self addSubview:self.datePicker];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(KToolBarHeight);
    }];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.and.equalTo(self.toolBar.mas_bottom);
    }];
}

#pragma mark - User Interaction

- (void)cancel {
    if ([self.delegate respondsToSelector:@selector(datePickerViewDidCancel:)]) {
        [self.delegate datePickerViewDidCancel:self];
    }
}

- (void)done {
    [self datePickerValueChanged:_datePicker];
    if ([self.delegate respondsToSelector:@selector(datePickerViewDidDone:)]) {
        [self.delegate datePickerViewDidDone:self];
    }
    
    if (self.dateChangeBlock) {
        self.dateChangeBlock(_datePicker);
    }
}

- (void)datePickerValueChanged:(UIDatePicker *)picker {
    if (self.callerView) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [formatter stringFromDate:[picker date]];
        [self.callerView setValue:date forKey:@"text"];
        
        if ([self.delegate respondsToSelector:@selector(datePickerValueChanged:)]) {
            [self.delegate datePickerValueChanged:self];
        }
    }
}


#pragma mark - Getter & Setter

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        _toolBar.backgroundColor = nil;
        _toolBar.translucent = YES;
        _toolBar.tintColor = [UIColor colorFromHexString:@"#4990E2"];

        UIButton *cancelBtn = [self toolBarButton];
        [cancelBtn setTitle:CancelTitle forState:UIControlStateNormal];
        [_toolBar addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(_toolBar);
        }];
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIButton *doneBtn = [self toolBarButton];
        [doneBtn setTitle:DoneTitle forState:UIControlStateNormal];
        [_toolBar addSubview:doneBtn];
        [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(_toolBar);
        }];
        [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
        _toolBar.items = @[cancelItem,flexItem, doneItem];
    }
    return _toolBar;
}

- (UIButton *)toolBarButton {
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:[UIColor colorFromHexString:@"#5eafff"] forState:UIControlStateNormal];
    return button;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.tintColor = [UIColor colorFromHexString:@"#4990E2"];
        // 设置UIDatePicker的显示模式
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        // 当值发生改变的时候调用的方法
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.toolBar.tintColor = tintColor;
    [self.datePicker setValue:tintColor forKey:@"textColor"];
}

- (void)setLastDateText:(NSString *)lastDateText {
    _lastDateText = lastDateText;
    if (_lastDateText && _lastDateText.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *lastDate = [formatter dateFromString:_lastDateText];
        if (lastDate) {
            [_datePicker setDate:lastDate animated:YES];
        }else {
            [_datePicker setDate:[NSDate date] animated:YES];
        }
    }else {
        [_datePicker setDate:[NSDate date] animated:YES];
    }
}

@end
