//
//  DLEmptyDataScrollView.h
//  PocketSLH
//
//  Created by yunyu on 16/4/18.
//
//

#import <UIKit/UIKit.h>
@import DZNEmptyDataSet;

typedef void (^EmptyViewCallback)(UIScrollView *scrollView);

@interface DLEmptyDataManager : NSObject <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**
 *  自定义空白视图，为空显示默认空数据视图
 */
@property (nonatomic, strong) UIView *customEmptyView;

/**
 *  空视图背景颜色，默认为#eeeeee
 */
@property (nonatomic, strong) UIColor *emptyViewColor;

/**
 *  空数据显示的空白页的标题
 */
@property (nonatomic, copy) NSString *noDataTitle;


/**
 *  error为nil显示no data view
 *  error DLNetworkNotReachable 显示网络未连接状态
 *  其余情况显示错误状态
 */
@property (nonatomic, strong) NSError *error;

/**
 *  @author liyanqin
 *
 *  empthView居中后向下偏移量
 */
@property (nonatomic, assign) CGFloat verticalOffset;


@property (nonatomic, copy) EmptyViewCallback actionButtonClickedHandler;

@end
