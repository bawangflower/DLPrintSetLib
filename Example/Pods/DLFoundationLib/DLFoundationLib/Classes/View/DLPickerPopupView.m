//
//  DLPickerPopupView.m
//  Pods
//
//  Created by GaoYuJian on 2017/4/21.
//
//

#import "DLPickerPopupView.h"
#import "DLAppMacro.h"
#import "DLAlertViewConfig.h"
@import Masonry;
@import Colours;

@interface DLPickerPopupView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray <id<DLPickerItemProtocol>> *items;

@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation DLPickerPopupView

+ (instancetype)pickerPopupWithTitle:(NSString *)title items:(NSArray <id<DLPickerItemProtocol>> *)items {
    DLPickerPopupView *pickerView = [[DLPickerPopupView alloc] initWithTitle:title items:items];
    return pickerView;
}

- (instancetype)initWithTitle:(NSString *)title items:(NSArray <id<DLPickerItemProtocol>> *)items {
    self = [super init];
    if (self) {
        self.title = title;
        self.items = items;
        self.configItem.popupType = DLPopupTypeBottomSheet;
        self.contentViewSize = CGSizeMake(SCREEN_WIDTH, 250);
    }
    return self;
}

- (void)viewDidLoad {
    [self setupView];
    
    // 设置默认选中
    self.preSelectedIndex = 0;
}

- (void)setupView {
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:[DLAlertViewConfig sharedConfig].defaultTextCancel forState:UIControlStateNormal];
    [cancelButton setTitleColor:[DLAlertViewConfig sharedConfig].tintColor forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 8.0;
    cancelButton.clipsToBounds = YES;
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 10, 10));
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8.0;
    contentView.clipsToBounds = YES;
    [self.contentView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cancelButton);
        make.bottom.equalTo(cancelButton.mas_top).offset(-10);
        make.top.equalTo(self.contentView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorFromHexString:@"#4a4a4a"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.title;
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(contentView);
        make.height.equalTo(@55);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorFromHexString:@"#D8D8D8"];
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.and.right.equalTo(contentView);
        make.top.equalTo(titleLabel.mas_bottom);
    }];
    
    self.pickerView = [[UIPickerView alloc] init];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    [contentView addSubview:_pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(contentView);
        make.top.equalTo(line.mas_bottom);
    }];
}

//- (void)show {
//    [self showWithBlock:nil];
//}
//
//- (void)showWithBlock:(MMPopupCompletionBlock)block {
//    [super showWithBlock:block];
//    
//    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectOneItem:)]) {
//        [self.delegate pickerView:self didSelectOneItem:[self.items firstObject]];
//    }
//}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _items.count;
}

#pragma mark - UIPickerViewDelegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row < _items.count) {
        id <DLPickerItemProtocol> item = _items[row];
        NSDictionary *attr = @{NSForegroundColorAttributeName : [UIColor colorFromHexString:@"#4990E2"]};
        return [[NSAttributedString alloc] initWithString:item.text attributes:attr];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row < _items.count) {
        id <DLPickerItemProtocol> item = _items[row];
        if ([self.delegate respondsToSelector:@selector(pickerView:didSelectOneItem:)]) {
            [self.delegate pickerView:self didSelectOneItem:item];
        }
        if (self.selectedHandler) {
            self.selectedHandler(self, item);
        }
    }
}

#pragma mark - Setter & Getter 
- (void)setPreSelectedIndex:(NSUInteger)preSelectedIndex {
    // 处理数据不存在的时候的边界
    if (self.items == nil || self.items.count == 0) {
        return;
    }
    
    // 设置上一次选中
    if (preSelectedIndex < self.items.count) {
        _preSelectedIndex = preSelectedIndex;
    }else {
        _preSelectedIndex = 0;
    }
    
    // 设置默认选中
    [self.pickerView selectRow:self.preSelectedIndex inComponent:0 animated:YES];
    [self.delegate pickerView:self didSelectOneItem:_items[preSelectedIndex]];
}

@end
