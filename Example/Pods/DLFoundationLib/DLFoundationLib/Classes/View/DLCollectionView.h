//
//  DLCollectionView.h
//  PocketSLH
//
//  Created by yunyu on 16/4/18.
//
//

#import <UIKit/UIKit.h>
#import "DLEmptyDataManager.h"

@interface DLCollectionView : UICollectionView

@property (nonatomic, strong) DLEmptyDataManager *emptyDataManager;

@end
