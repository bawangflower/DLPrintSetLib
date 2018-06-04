//
//  DLWaterfallLayout.m
//  PocketSLH
//
//  Created by yunyu on 16/4/15.
//
//

#import "DLWaterfallLayout.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

@interface DLWaterfallLayout ()

/**
 *  单元格数量
 */
@property (nonatomic, assign) NSUInteger numberOfCells;

/**
 *  行数
 */
@property (nonatomic, assign) NSUInteger column;

/**
 *  间距
 */
@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, assign) CGFloat cellWidth;

/**
 *  布局宽度
 */
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) NSMutableArray *cellXArray;

@property (nonatomic, strong) NSMutableArray *cellYArray;

@property (nonatomic, strong) NSMutableArray *cellHeightArray;

@end

@implementation DLWaterfallLayout

#pragma mark - Layout

- (void)prepareLayout {
    [self setupData];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(_width, [[_cellYArray valueForKeyPath:@"@max.self"] floatValue]);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    [self setupYCoordinate];
    
    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:_numberOfCells];
    for (NSInteger index = 0; index < _numberOfCells; index++) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [attributes addObject:attribute];
    }
    
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        [attributes addObject:attribute];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame = CGRectZero;
    CGFloat cellH = [self.layoutDelegate heightOfCellWithCollectionView:self.collectionView collectionViewLayout:self indexPath:indexPath];
    NSUInteger minYIndex = [self minYIndex];
    CGFloat cellX = [_cellXArray[minYIndex] floatValue];
    CGFloat cellY = [_cellYArray[minYIndex] floatValue];
    frame = CGRectMake(cellX, cellY, _cellWidth, cellH);
    
    attributes.frame = frame;
    
    _cellYArray[minYIndex] = @(cellY + cellH + _margin);
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    CGFloat height = 0;
    if ([self.layoutDelegate respondsToSelector:@selector(heightOfHeaderWithCollectionView:collectionViewLayout:section:)]) {
        height = [self.layoutDelegate heightOfHeaderWithCollectionView:self.collectionView collectionViewLayout:self section:indexPath.section];
    }
    attributes.frame = CGRectMake(0, 0, _cellWidth, height);
    
    return attributes;
}

#pragma mark - Data

- (void)setupData {
    self.numberOfCells = [self.collectionView numberOfItemsInSection:0];
    self.column = [self.layoutDelegate numberOfColumnWithCollectionView:self.collectionView collectionViewLayout:self];
    self.margin = [self.layoutDelegate marginOfCellWithCollcetionView:self.collectionView collectionViewLayout:self];
    if ([self.layoutDelegate respondsToSelector:@selector(widthOfCollectionView:collectionViewLayout:)]) {
       self.width = [self.layoutDelegate widthOfCollectionView:self.collectionView collectionViewLayout:self];
    } else {
        self.width = SCREEN_WIDTH;
    }
    
    self.cellWidth = (_width - (_column + 1) * _margin) / _column;
    
    [self setupXCoordinate];
}

- (void)setupXCoordinate {
    self.cellXArray = [NSMutableArray arrayWithCapacity:_column];
    for (NSInteger index = 0; index < _column; index++) {
        [_cellXArray addObject:@(_margin + (_margin + _cellWidth) * index)];
    }
}

- (void)setupYCoordinate {
    self.cellYArray = [NSMutableArray arrayWithCapacity:_column];
    for (NSInteger index = 0; index < _column; index++) {
        CGFloat columnMargin = 0.0;
        if ([self.layoutDelegate respondsToSelector:@selector(topMarginOfColumnWithCollectionView:collectionViewLayout:column:)]) {
            columnMargin = [self.layoutDelegate topMarginOfColumnWithCollectionView:self.collectionView collectionViewLayout:self column:index];
        }
        [_cellYArray addObject:@(columnMargin)];
    }
}

- (NSUInteger)minYIndex {
    NSNumber *minY = [_cellYArray firstObject];
    NSUInteger minIndex = 0;
    for (NSInteger index = 1; index < _cellYArray.count; index++) {
        NSNumber *cellY = _cellYArray[index];
        if (cellY.floatValue < minY.floatValue) {
            minY = cellY;
            minIndex = index;
        }
    }
    
    return minIndex;
}

#pragma mark - Setters And Getters

- (NSMutableArray *)cellHeightArray {
    if (!_cellXArray) {
        _cellXArray = [NSMutableArray arrayWithCapacity:_column];
    }
    return _cellHeightArray;
}

@end
