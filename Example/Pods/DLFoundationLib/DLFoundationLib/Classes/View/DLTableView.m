//
//  DLTableView.m
//  PocketSLH
//
//  Created by yunyu on 16/4/11.
//
//

#import "DLTableView.h"

@interface DLTableView () 

@property (nonatomic, strong, readwrite) DLEmptyDataManager *emptyDataManager;

@end

@implementation DLTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
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
