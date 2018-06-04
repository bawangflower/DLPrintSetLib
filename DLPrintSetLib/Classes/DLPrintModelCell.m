//
//  DLPrintModelCell.m
//  StaffAssistant
//
//  Created by LiYanQin on 2018/4/4.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import "DLPrintModelCell.h"
#import "DLPrintModelWebVC.h"
#import "DLPrintSetUtility.h"
#import <Masonry/Masonry.h>
#import <DLFoundationLib/UIWindow+DLCategory.h>

@import SDWebImage;
@import Colours;
@interface DLPrintModelCell ()

@property (nonatomic, strong) UIImageView *picView;

@property (nonatomic, strong) UIImageView *checkImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation DLPrintModelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.contentView.backgroundColor = [UIColor whiteColor];
    _picView = [[UIImageView alloc] init];
    _picView.layer.borderWidth = 1;
    _picView.layer.borderColor = [UIColor colorFromHexString:@"#c8c8c8"].CGColor;
    _picView.backgroundColor = [UIColor colorFromHexString:@"#f7f7f7"];
    [self.contentView addSubview:_picView];
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    _picView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectModel:)];
    [_picView addGestureRecognizer:tap];
    
    _checkImageView = [[UIImageView alloc] initWithImage:[DLPrintSetUtility dl_bundleImageWithName:@"printModelSelect"]];
    [self.contentView addSubview:_checkImageView];
    [_checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.top.mas_equalTo(6);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.top.equalTo(_picView.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *editButton = [[UIButton alloc] init];
    [editButton setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor colorFromHexString:@"#3d4245"] forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.right.mas_equalTo(-10);
    }];
    [editButton addTarget:self action:@selector(editModal:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - User Interaction

/**
 *  @author liyanqin
 *
 *  选择模板
 *
 */
- (void)selectModel:(UIGestureRecognizer *)tapGes {
    if (_model.selected.boolValue) {
        return;
    }
    if (self.selectModelBlock) {
        self.selectModelBlock(_model);
    }
}

/**
 *  @author liyanqin
 *
 *  编辑模板
 *
 */
- (void)editModal:(UIButton *)button {
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    //上一句话是防止手动先把设备置为横屏,导致下面的语句失效.
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    
    DLPrintModelWebVC *webVC = [[DLPrintModelWebVC alloc] initWithModel:_model];
    UIViewController *visibleController = [[[UIApplication sharedApplication].delegate window] dl_visibleViewController];
    [visibleController.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Setters

- (void)setModel:(DLPrintModel *)model {
    _model = model;
//    [_picView sd_setImageWithURL:[]]
    _nameLabel.text = _model.name;
    _checkImageView.hidden = !_model.selected.boolValue;
}

@end
