//
//  LTCRefreshTableHeaderView.m
//  CWTableViewPullRefresh
//
//  Created by ly on 14-1-8.
//  Copyright (c) 2014年 ly. All rights reserved.
//

#import "LTCRefreshTableHeaderView.h"

@interface LTCRefreshTableHeaderView ()

@property (strong, nonatomic) UILabel *textLabel;

@property (strong, nonatomic) UIImageView *animationView;

@property (strong, nonatomic) UIImageView *placeholderView;

@property (strong, nonatomic) NSArray *animationImages;

@end

@implementation LTCRefreshTableHeaderView

- (id)initWithAnimationImages:(NSArray *)images
{
    self = [super init];
    if (self) {
        NSParameterAssert([images count]>1);
        
        // Save animation images
        self.animationImages = images;
        
        // Set background color
        self.backgroundColor = [UIColor clearColor];
        
        // Load views
        [self loadViews];
    }
    return self;
}

- (void)loadViews
{
    [self addSubview:self.textLabel];
    
    if ([self.animationImages count] > 1)
    {
        // 添加 animation view 和 place holder view
        [self addSubview:self.animationView];
        [self addSubview:self.placeholderView];
        
        self.animationView.animationImages = self.animationImages;
        self.placeholderView.image         = [self.animationImages firstObject];
    }
}


#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat h = CGRectGetHeight(self.frame);
    
    // 设置 text view 的 frame
    self.textLabel.frame = CGRectMake(0.0f, h - 30.0f, w, 20.0f);
    
    // 设置图片的位置
    CGRect imgFrame = CGRectMake(42.0, h-47.0, 60, 60);
    self.animationView.frame   = imgFrame;
    self.placeholderView.frame = imgFrame;
}

#pragma mark - Toggle state
- (void)onRefreshPulling
{
    self.textLabel.text = NSLocalizedString(@"可以松开了...", @"Release to refresh status");
}

- (void)onRefreshNormal
{
    self.textLabel.text = NSLocalizedString(@"下拉刷新", @"Pull down to refresh status");
    [self stopAnimation];
}

- (void)onRefreshLoading
{
    self.textLabel.text = NSLocalizedString(@"            别着急，正在努力加载...", @"Loading Status");
    [self startAnimation];
}

- (void)cwRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    [super cwRefreshScrollViewDidScroll:scrollView];
    
    if (self.state != CWPullRefreshLoading) {
        CGFloat offsetY = fabs(scrollView.contentOffset.y);
        if (offsetY < 5.0f) {
            [self hideImagePlaceholder];
            return;
        }
        [self showImagePlaceholderAlpha:offsetY/45.0];
    } else {
        [self hideImagePlaceholder];
    }
}

#pragma mark - Animation
- (void)startAnimation
{
    [self hideImagePlaceholder];
    
    if (!self.animationView.isAnimating) {
        [self.animationView startAnimating];
    }
}

- (void)stopAnimation
{
    [self.animationView stopAnimating];
    [self hideImagePlaceholder];
}

- (void)showImagePlaceholderAlpha:(CGFloat)alpha
{
    [UIView animateWithDuration:0.25 animations:^{
        self.placeholderView.alpha = alpha;
    }];
}

- (void)hideImagePlaceholder
{
    self.placeholderView.alpha = 0.0;
}

#pragma mark - Property
- (UILabel *)textLabel
{
    if ( _textLabel == nil ) {
        _textLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textColor        = [UIColor colorWithRed:118.0/255.0 green:123.0/255.0 blue:127.0/255.0 alpha:1.0];
        _textLabel.backgroundColor  = [UIColor clearColor];
        _textLabel.shadowOffset     = CGSizeMake(0.0f, 1.0f);
        _textLabel.shadowColor      = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _textLabel.font             = [UIFont boldSystemFontOfSize:15.0f];
        _textLabel.textAlignment    = NSTextAlignmentCenter;
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _textLabel;
}

- (UIImageView *)animationView
{
    if ( _animationView == nil ) {
        _animationView = [[UIImageView alloc] init];
        _animationView.animationDuration = 0.3;
    }
    return _animationView;
}

- (UIImageView *)placeholderView
{
    if ( _placeholderView == nil ) {
        _placeholderView = [[UIImageView alloc] init];
        _placeholderView.alpha = 0.0;
    }
    return _placeholderView;
}

@end
