//
//  DLImageCollectionViewCell.m
//  PocketSLH
//
//  Created by yunyu on 16/5/6.
//
//

#import "DLImageCollectionViewCell.h"
#import "Masonry.h"

@interface DLImageCollectionViewCell ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation DLImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

@end
