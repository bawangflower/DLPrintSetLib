//
//  DLPrintModelCollectionView.m
//  StaffAssistant
//
//  Created by LiYanQin on 2018/4/8.
//  Copyright © 2018年 ecool. All rights reserved.
//

#import "DLPrintModelCollectionView.h"
#import "DLPrintModelCell.h"
#import "DLPrintModel.h"

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

static NSString *const KCellIdentifier = @"KCell";

@interface DLPrintModelCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>

@end;

@implementation DLPrintModelCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
        self.contentInset = UIEdgeInsetsMake(10, 14, 10, 14);
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[DLPrintModelCell class] forCellWithReuseIdentifier:KCellIdentifier];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)reloadData {
    [self invalidateIntrinsicContentSize];
    [super reloadData];
}

- (CGSize)intrinsicContentSize {
    [self layoutIfNeeded];
    CGFloat count = _models.count;

    CGFloat rowNum = ceilf(count/(CGFloat)2);
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGSize size = flowLayout.itemSize;
    return CGSizeMake(UIViewNoIntrinsicMetric, rowNum *size.height + (rowNum-1)*14 +20);
}

#pragma mark - UIcollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DLPrintModelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KCellIdentifier forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    WEAKSELF
    cell.selectModelBlock = ^(DLPrintModel *model) {
        STRONGSELF
        if (strongSelf.selectModelBlock) {
            strongSelf.selectModelBlock(model);
        };
    };
    return cell;
}

- (void)setModels:(NSMutableArray<DLPrintModel *> *)models {
    _models = models;
    [self reloadData];
}

@end
