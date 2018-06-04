//
//  DLTableView.h
//  PocketSLH
//
//  Created by yunyu on 16/4/11.
//
//

#import <UIKit/UIKit.h>
#import "DLEmptyDataManager.h"

@interface DLTableView : UITableView

@property (nonatomic, strong, readonly) DLEmptyDataManager *emptyDataManager;

@end
