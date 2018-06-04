//
//  DLCheckBox.h
//  PocketSLH
//
//  Created by yunyu on 16/3/3.
//
//

#import <UIKit/UIKit.h>

@interface DLCheckBox : UIButton

@property (nonatomic, strong) id object;

/**
 *  default is YES
 */
@property (nonatomic, assign) BOOL isAutoChangeStatus;

@end
