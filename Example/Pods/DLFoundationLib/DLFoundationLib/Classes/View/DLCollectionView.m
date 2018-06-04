//
//  DLCollectionView.m
//  PocketSLH
//
//  Created by yunyu on 16/4/18.
//
//

#import "DLCollectionView.h"

@implementation DLCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.emptyDataSetSource = self.emptyDataManager;
        self.emptyDataSetDelegate = self.emptyDataManager;
    }
    return self;
}


- (DLEmptyDataManager *)emptyDataManager {
    if (!_emptyDataManager) {
        _emptyDataManager = [[DLEmptyDataManager alloc] init];
    }
    return _emptyDataManager;
}

@end
