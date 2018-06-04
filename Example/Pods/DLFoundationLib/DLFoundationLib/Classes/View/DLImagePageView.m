//
//  DLImagePageView.m
//  PocketSLH
//
//  Created by yunyu on 16/3/18.
//
//

#import "DLImagePageView.h"
#import "Masonry.h"
#import "NSBundle+DLFoundationLib.h"
@import SDWebImage;

@interface DLImagePageView () <UIScrollViewDelegate>

/**
 *  图片URL
 */
@property (nonatomic, copy) NSArray *imageURLs;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong, readwrite) UIPageControl *pageCtl;

@end

@implementation DLImagePageView

#pragma mark - LifeCycle

- (instancetype)initWithURLs:(NSArray *)imageURLs {
    self = [super init];
    
    if (self) {
        _imageURLs = imageURLs;
        [self setup];
    }
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)setup {
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.contentView = [[UIView alloc] init];
    [scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.equalTo(scrollView);
    }];
    
    // add imageViews
    UIView *leftView;
    if (_imageURLs.count > 0) {
        for (int index = 0; index < _imageURLs.count; index++) {
            NSURL *imageURL = _imageURLs[index];
            if (index < 2) {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.clipsToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.tag = index;
                [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"nopic" inBundle:[NSBundle dl_fundationLibImageBundle] compatibleWithTraitCollection:nil]];
                [_contentView addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(leftView ? leftView.mas_right : @0);
                    make.top.and.bottom.equalTo(_contentView);
                    make.height.equalTo(_contentView);
                    make.width.equalTo(_scrollView);
                }];
                leftView = imageView;
            } else {
                [[SDWebImageManager sharedManager] loadImageWithURL:imageURL options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    
                }];
            }
        }
    } else {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"nopic"];
        [_contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(_contentView);
            make.edges.equalTo(_contentView);
        }];
    }
    
    // pageControl
    self.pageCtl.numberOfPages = _imageURLs.count;
    [self.pageCtl addTarget:self action:@selector(currentPageChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageCtl];
    [_pageCtl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_scrollView.frame.size.width > 0) {
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(_scrollView.frame.size.width * _imageURLs.count));
        }];
        [_scrollView setNeedsDisplay];
        [_scrollView layoutIfNeeded];
    }
}

#pragma mark - User Interaction

- (void)currentPageChanged {
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * _pageCtl.currentPage, 0) animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self buildRenderView];
    
    _pageCtl.currentPage = floor(scrollView.contentOffset.x/scrollView.bounds.size.width + 0.5);
}

- (void)buildRenderView {
    UIImageView *currentImageView = [self imageViewWithIndex:_pageCtl.currentPage];
    UIImageView *noCurrentImageView = [self noCurrentImageView];
    
    if (currentImageView && noCurrentImageView) {
        NSInteger nextPage = NSNotFound;
        if (_scrollView.contentOffset.x > currentImageView.frame.origin.x) {
            nextPage = _pageCtl.currentPage + 1;
        } else if(_scrollView.contentOffset.x < currentImageView.frame.origin.x) {
            nextPage = _pageCtl.currentPage - 1;
        }
        
        if (nextPage>=0 && nextPage<_imageURLs.count && noCurrentImageView.tag != nextPage) {
            noCurrentImageView.tag = nextPage;
            if (noCurrentImageView.tag < _imageURLs.count) {
                NSURL *imageURL = _imageURLs[noCurrentImageView.tag];
                [noCurrentImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"nopic" inBundle:[NSBundle dl_fundationLibImageBundle] compatibleWithTraitCollection:nil]];
            }
            
            [self remakeConstraintsForImageView:currentImageView];
            [self remakeConstraintsForImageView:noCurrentImageView];
            
            [_scrollView setNeedsDisplay];
            [_scrollView layoutIfNeeded];
        }
    }
}

- (void)remakeConstraintsForImageView:(UIImageView *)imageView {
    [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(_contentView);
        make.height.and.width.equalTo(_scrollView);
        make.left.equalTo(@(_scrollView.bounds.size.width * imageView.tag));
 
    }];
}

#pragma mark - Setter And Getter

- (UIPageControl *)pageCtl {
    if (!_pageCtl) {
        _pageCtl = [[UIPageControl alloc] init];
        _pageCtl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageCtl;
}

#pragma mark - Internal Helpers

- (UIImageView *)noCurrentImageView {
    for (UIImageView *imageView in [self subImageViews]) {
        if (imageView.tag != _pageCtl.currentPage) {
            return imageView;
        }
    }
    
    return nil;
}

- (NSArray *)subImageViews {
    NSMutableArray *imageViews = [@[] mutableCopy];
    for (UIView *subView in _contentView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [imageViews addObject:subView];
        }
    }
    
    return imageViews;
}

- (UIImageView *)imageViewWithIndex:(NSInteger)index {
    for (UIImageView *imageView in [self subImageViews]) {
        if (imageView.tag == index) {
            return imageView;
        }
    }
    
    return nil;
}

@end
