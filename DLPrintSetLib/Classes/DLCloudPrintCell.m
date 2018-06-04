//
//  DLCloudPrintCell.m
//  StaffAssistant
//
//  Created by LiYanQin on 2018/4/4.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import "DLCloudPrintCell.h"
#import "DLPrintModelCollectionView.h"
#import "DLPrintModel.h"
#import <Masonry/Masonry.h>
#import <DLFoundationLib/UIImage+DLUtility.h>
#import <DLFoundationLib/DLAppMacro.h>

@import Colours;

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

#define CommonModalTitle NSLocalizedString(@"标准模板", nil)
#define CustomModalTitle NSLocalizedString(@"自定义模板", nil)

@interface DLCloudPrintCell ()

@property (nonatomic, strong) UIButton *commonButton;

@property (nonatomic, strong) UIButton *customButton;

@property (nonatomic, strong) DLPrintModelCollectionView *collectionView;

@end

@implementation DLCloudPrintCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    _commonButton = [self contentButton];
    _commonButton.tag = DLModalTypeCommon;;
    [_commonButton setTitle:CommonModalTitle forState:UIControlStateNormal];
    [self.contentView addSubview:_commonButton];
    [_commonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).multipliedBy(0.5);
        make.top.mas_equalTo(12);
    }];
    [_commonButton addTarget:self action:@selector(changeModalStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    _customButton = [self contentButton];
    _customButton.tag = DLModalTypeCustom;
    [_customButton setTitle:CustomModalTitle forState:UIControlStateNormal];
    [self.contentView addSubview:_customButton];
    [_customButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).multipliedBy(1.5);
        make.top.mas_equalTo(12);
    }];
    [_customButton addTarget:self action:@selector(changeModalStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorFromHexString:@"#eeeeee"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_commonButton.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self.contentView);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 14;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-10-14*2)/2, (SCREEN_WIDTH-10-14*2)/2 *1.17);
    _collectionView = [[DLPrintModelCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(lineView.mas_bottom);
    }];
    //选中某个模板
    WEAKSELF
    _collectionView.selectModelBlock = ^(DLPrintModel *model) {
        STRONGSELF
        if (model.templateComFlag.boolValue) {
            for (DLPrintModel *commonModel in strongSelf.commonModels) {
                if (commonModel == model) {
                    commonModel.selected = @(1);
                }else {
                    commonModel.selected = @(0);
                }
            }
            for (DLPrintModel *customModel in strongSelf.customModels) {
                customModel.selected = @(0);
            }
            strongSelf.collectionView.models = strongSelf.commonModels;
        }else {
            for (DLPrintModel *customModel in strongSelf.customModels) {
                if (customModel == model) {
                    customModel.selected = @(1);
                }else {
                    customModel.selected = @(0);
                }
            }
            for (DLPrintModel *commonModel in strongSelf.commonModels) {
                commonModel.selected = @(0);
            }
            strongSelf.collectionView.models = strongSelf.customModels;
        }
    };
}

- (UIButton *)contentButton {
    UIButton *button = [[UIButton alloc] init];
    button.layer.cornerRadius = 12.5;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor colorFromHexString:@"#3d4245"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(25);
    }];
    return button;
}

/**
 *  @author liyanqin
 *
 *  切换标准自定义模板
 *
 */
- (void)changeModalStatus:(UIButton *)button {
    if (button.selected) {
        return;
    }
    
    if (button.tag == DLModalTypeCommon) {
        _commonButton.backgroundColor = [UIColor colorFromHexString:@"#ff3b30"];
        _customButton.backgroundColor = [UIColor clearColor];
        _commonButton.selected = YES;
        _customButton.selected = NO;
    }else {
        _commonButton.backgroundColor = [UIColor clearColor];
        _customButton.backgroundColor = [UIColor colorFromHexString:@"#ff3b30"];
        _commonButton.selected = NO;
        _customButton.selected = YES;
    }
    
    if (self.changeModalTypeBlock) {
        self.changeModalTypeBlock(button.tag);
    }
}

#pragma mark - Setters and Getters

- (void)setModelType:(DLModalType)modelType {
    if (modelType == DLModalTypeCommon) {
        self.collectionView.models = _commonModels;
        [self changeModalStatus:_commonButton];
    }else {
        self.collectionView.models = _customModels;
        [self changeModalStatus:_customButton];
    }
    
}

@end
