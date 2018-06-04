//
//  DLMineSettingCell.m
//  StaffAssistant
//
//  Created by yjj on 2017/4/19.
//  Copyright © 2017年 ecool. All rights reserved.
//

#import "DLMineSettingCell.h"
#import "UIView+Size.h"
#import <DLFoundationLib/DLCheckBox.h>

@import Colours;
@implementation DLMineSettingCell {
    UIView   *_separatorLine;
    UISwitch *_switch;
    UIView   *_unreadMessageIndicatorView;
    DLCheckBox *_checkBox;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.height = 44;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor colorFromHexString:@"#3d4245"];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor colorFromHexString:@"#eeeeee"];
        [self.contentView addSubview:_separatorLine];
        
        if ([reuseIdentifier isEqualToString:KDLMineSettingCellHaveCheckBoxReuseId]) {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            _checkBox = [[DLCheckBox alloc] init];
            [_checkBox addTarget:self action:@selector(checkBoxStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_checkBox];
        }
        
        _unreadMessageIndicatorView = [[UIView alloc] init];
        _unreadMessageIndicatorView.backgroundColor = [UIColor redColor];
        _unreadMessageIndicatorView.layer.masksToBounds = YES;
        _unreadMessageIndicatorView.layer.cornerRadius = 3;
        _unreadMessageIndicatorView.hidden = YES;
        [self.contentView addSubview:_unreadMessageIndicatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.reuseIdentifier isEqualToString:kDLMineSettingCellHaveImageReuseId]) {
        self.imageView.left = 16;
        self.imageView.centerY = self.height / 2.0;
        self.imageView.size = CGSizeMake(16, 16);
        
        self.textLabel.left = 50;
    }else {
        self.imageView.frame = CGRectZero;
        
        self.textLabel.left = 16;
    }
    self.textLabel.centerY = self.height / 2.0;
    
    if ([self.reuseIdentifier isEqualToString:KDLMineSettingCellHaveCheckBoxReuseId]) {
        _checkBox.width = 30;
        _checkBox.height = 30;
        _checkBox.left = self.width - _checkBox.width - 20;;
        _checkBox.centerY = self.height / 2.0;
    }
    
    self.detailTextLabel.top = 0;
    self.detailTextLabel.left = self.textLabel.left + self.textLabel.width + 5;
    self.detailTextLabel.height = self.height;
    self.detailTextLabel.width = self.width - self.detailTextLabel.left - 40;
    
    
    _unreadMessageIndicatorView.size = CGSizeMake(6, 6);
    _unreadMessageIndicatorView.left = CGRectGetMaxX(self.textLabel.frame);
    _unreadMessageIndicatorView.top = self.height / 2.0 - 10;
    
    _separatorLine.left = 0;
    _separatorLine.height = 1;
    _separatorLine.width = self.width;
    _separatorLine.top = self.height - _separatorLine.height;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.accessoryType = userInteractionEnabled ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

#pragma mark - User Interaction
- (void)switchStatusChanged:(UISwitch *)sw {
    if (self.switchStatusHandler) {
        self.switchStatusHandler(sw);
    }
}

- (void)checkBoxStatusChanged:(DLCheckBox *)checkBox {
    if (self.checkBoxStatusHandler) {
        self.checkBoxStatusHandler(checkBox);
    }
}

#pragma mark - Setter
- (void)setSwitchIsOpen:(BOOL)switchIsOpen {
    _switchIsOpen = switchIsOpen;
    [_switch setOn:switchIsOpen];
}

- (void)setCheckBoxIsSelect:(BOOL)checkBoxIsSelect {
    _checkBoxIsSelect = checkBoxIsSelect;
    _checkBox.selected = _checkBoxIsSelect;
}

- (void)setShowUnreadMessageIndicator:(BOOL)showUnreadMessageIndicator {
    _showUnreadMessageIndicator = showUnreadMessageIndicator;
    _unreadMessageIndicatorView.hidden = !showUnreadMessageIndicator;
}

@end
