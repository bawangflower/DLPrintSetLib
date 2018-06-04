//
//  DLWaterfallLayout.h
//  PocketSLH
//
//  Created by yunyu on 16/4/15.
//
//  瀑布流

#import <UIKit/UIKit.h>

@class DLWaterfallLayout;

@protocol DLWaterfallLayoutDelegate <NSObject>

@required

// 列数
- (NSUInteger)numberOfColumnWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(DLWaterfallLayout *)collectionViewLayout;

// cell 之间的间距
- (CGFloat)marginOfCellWithCollcetionView:(UICollectionView *)collectionView collectionViewLayout:(DLWaterfallLayout *)collectionViewLayout;

// cell 高度
- (CGFloat)heightOfCellWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(DLWaterfallLayout *)collectionViewLayout indexPath:(NSIndexPath *)indexPath;

@optional

// collectionView 宽度 default screen width
- (CGFloat)widthOfCollectionView:(UICollectionView *)collectionView collectionViewLayout:(DLWaterfallLayout *)collectionViewLayout;

// 每列的顶部间距 default is 0.0
- (CGFloat)topMarginOfColumnWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(DLWaterfallLayout *)collectionViewLayout column:(NSUInteger)column;

- (CGFloat)heightOfHeaderWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(DLWaterfallLayout *)collectionViewLayout section:(NSUInteger)section;

@end

@interface DLWaterfallLayout : UICollectionViewLayout

@property (nonatomic, weak) id<DLWaterfallLayoutDelegate> layoutDelegate;

@end
