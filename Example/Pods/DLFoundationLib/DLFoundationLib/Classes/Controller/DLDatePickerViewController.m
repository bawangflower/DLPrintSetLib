//
//  DLDatePickerViewController.m
//  Pods
//
//  Created by yjj on 2017/6/20.
//
//

#import "DLDatePickerViewController.h"
@import Masonry;

#define KPreferredContentSize CGSizeMake(250 * ([UIScreen mainScreen].bounds.size.width / 400) , 250)

@interface DLDatePickerViewController ()

@property (nonatomic, strong, readwrite) DLDatePickerView *datePickerView;

@end

@implementation DLDatePickerViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.preferredContentSize = KPreferredContentSize;
    
    [self.view addSubview:self.datePickerView];
    [self.datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0,* )) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        }else {
            make.edges.equalTo(self.view);
        }
    }];
}

#pragma mark - Getter 

- (DLDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[DLDatePickerView alloc] init];
    }
    return _datePickerView;
}

@end
