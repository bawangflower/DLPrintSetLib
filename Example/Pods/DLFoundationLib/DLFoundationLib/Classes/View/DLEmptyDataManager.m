//
//  DLEmptyDataScrollView.m
//  PocketSLH
//
//  Created by yunyu on 16/4/18.
//
//

#import "DLEmptyDataManager.h"
#import <Colours/Colours.h>
#import "NSBundle+DLFoundationLib.h"

#define MESSAGE_CANNOT_CONNECT DLLocalizedString(@"无法连接")
#define MESSAGE_ERROR DLLocalizedString(@"错误!")
#define MESSAGE_NO_DATA DLLocalizedString(@"暂无数据")

typedef NS_ENUM(NSUInteger, DLEmptyViewType) {
    DLEmptyViewNotShowType,
    DLEmptyViewNoDataType,
    DLEmptyViewNoNetworkType,
    DLEmptyViewDataErrorType,
};

@interface DLEmptyDataManager () 

@property (nonatomic, assign) DLEmptyViewType type;

@end

@implementation DLEmptyDataManager

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    UIImage *image;
    switch (_type) {
        case DLEmptyViewNoDataType: {
            image = [self imageWithName:@"no_data_status"];
            break;
        }
        case DLEmptyViewNoNetworkType: {
            image = [self imageWithName:@"no_network_status"];
            break;
        }
        case DLEmptyViewDataErrorType: {
            image = nil;
            break;
        }
        case DLEmptyViewNotShowType: {
            return nil;
            break;
        }
    }
    
    return image;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    switch (_type) {
        case DLEmptyViewNoDataType: {
            text = self.noDataTitle;
            break;
        }
        case DLEmptyViewNoNetworkType: {
            text = MESSAGE_CANNOT_CONNECT;
            break;
        }
        case DLEmptyViewDataErrorType: {
            text = MESSAGE_ERROR;
            break;
        }
        case DLEmptyViewNotShowType: {
            return nil;
            break;
        }
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#bbbbbb"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (_type == DLEmptyViewDataErrorType) {
        NSString *text = self.error.userInfo[@"name"];
        
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                     NSForegroundColorAttributeName: [UIColor colorFromHexString:@"#999999"],
                                     NSParagraphStyleAttributeName: paragraph};
        if (text) {
            return [[NSAttributedString alloc] initWithString:text attributes:attributes];
        } else {
            return nil;
        }
    }else {
        return nil;
    }
}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.emptyViewColor;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    return _customEmptyView;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.verticalOffset;
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return _type != DLEmptyViewNotShowType;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
    if (_actionButtonClickedHandler) {
        _actionButtonClickedHandler(scrollView);
    }
}

#pragma mark - Setters And Getters

- (void)setError:(NSError *)error {
    _error = error;
    if (error == nil) {
        self.type = DLEmptyViewNoDataType;
    }else if (error.code == NSURLErrorNotConnectedToInternet) {
        self.type = DLEmptyViewNoNetworkType;
    }else {
        self.type = DLEmptyViewDataErrorType;
    }
}

- (NSString *)noDataTitle {
    if (!_noDataTitle) {
        _noDataTitle = MESSAGE_NO_DATA;
    }
    return _noDataTitle;
}

- (UIColor *)emptyViewColor {
    if (!_emptyViewColor) {
        _emptyViewColor = [UIColor colorFromHexString:@"#eeeeee"];
    }
    return _emptyViewColor;
}

#pragma mark - Internal Helpers

- (UIImage *)imageWithName:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle dl_fundationLibImageBundle] compatibleWithTraitCollection:nil];
}

@end
