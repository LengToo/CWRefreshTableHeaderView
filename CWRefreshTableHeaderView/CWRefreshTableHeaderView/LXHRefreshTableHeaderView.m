//
//  LXHRefreshTableHeaderView.m
//  CWTableViewPullRefresh
//
//  Created by ly on 14-1-8.
//  Copyright (c) 2014年 ly. All rights reserved.
//

#import "LXHRefreshTableHeaderView.h"

@interface LXHRefreshTableHeaderView ()

@property (strong, nonatomic) UIImageView *placeholderView;

@property (strong, nonatomic) UIImageView *animationImageView;

@end

@implementation LXHRefreshTableHeaderView
{
    BOOL animating;
}

- (id)initWithPlaceholder:(UIImage *)placeholder animationImage:(UIImage *)animationImage
{
    self = [super init];
    if (self) {
        self.placeholderView.image    = placeholder;
        self.animationImageView.image = animationImage;
        
        // Load views
        [self loadViews];
    }
    return self;
}

- (void)loadViews
{
    [self addSubview:self.textLabel];
    [self addSubview:self.detailTextLabel];
    [self addSubview:self.placeholderView];
    [self addSubview:self.animationImageView];
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat h = CGRectGetHeight(self.frame);
    
    self.textLabel.frame = CGRectMake(0.0, h - 40.0, w, 20.0);
    self.detailTextLabel.frame = CGRectMake(0.0, h-23.0, w, 20.0);
    
    self.placeholderView.frame = CGRectMake(36.0, h-49.0, 51.0, 48.0);
    self.animationImageView.frame = CGRectMake(w-83, h-38.0, 30.0, 30.0);
}

#pragma mark - Toggle state

- (void)onRefreshPulling
{
    self.textLabel.text = @"可以松开了...";
}

- (void)onRefreshNormal
{
    self.textLabel.text = @"下拉刷新";
    [self refreshLastUpdatedDate];
    [self stopAnimation];
}

- (void)onRefreshLoading
{
    self.textLabel.text = @"正在制冷中...";
    [self startAnimation];
}


#pragma mark - Animation

- (void)startAnimation
{
    if (!animating) {
        animating = YES;
        [self spinWithOptions:UIViewAnimationOptionCurveLinear];
    }
}

- (void)stopAnimation
{
    animating = NO;
}


- (void)spinWithOptions:(UIViewAnimationOptions)options
{
    [UIView animateWithDuration: 0.1f delay: 0.0f options: options
     animations: ^{
         self.animationImageView.transform = CGAffineTransformRotate(self.animationImageView.transform, M_PI / 2);
     }
     completion: ^(BOOL finished) {
         if (finished) {
             if (animating) {
                 // if flag still set, keep spinning with constant speed
                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                 // one last spin, with deceleration
                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
             }
         }
     }];
}


#pragma mark - Refresh date

- (void)refreshLastUpdatedDate
{
	if ([self.delegate respondsToSelector:@selector(lxhRefreshTableHeaderDataSourceLastUpdated:)])
    {
		NSDate *date = [(id<LXHRefreshTableHeaderDelegate>)self.delegate lxhRefreshTableHeaderDataSourceLastUpdated:self];
        
		self.detailTextLabel.text = [NSString stringWithFormat:@"更新于: %@", [self.dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:self.detailTextLabel.text forKey:@"lxhRefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    else
    {
		self.detailTextLabel.text = nil;
	}
}


#pragma mark - Property

- (UIImageView *)placeholderView
{
    if ( _placeholderView == nil ) {
        _placeholderView = [[UIImageView alloc] init];
    }
    return _placeholderView;
}

- (UIImageView *)animationImageView
{
    if ( _animationImageView == nil ) {
        _animationImageView = [[UIImageView alloc] init];
    }
    return _animationImageView;
}

- (UILabel *)textLabel
{
    if ( _textLabel == nil ) {
        _textLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment   = NSTextAlignmentCenter;
        _textLabel.font            = [UIFont boldSystemFontOfSize:15.0f];
        _textLabel.textColor       = [UIColor colorWithRed:118.0/255.0 green:123.0/255.0 blue:127.0/255.0 alpha:1.0];
        _textLabel.shadowColor     = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _textLabel.shadowOffset    = CGSizeMake(0.0f, 1.0f);
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel
{
    if ( _detailTextLabel == nil ) {
        _detailTextLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailTextLabel.backgroundColor = [UIColor clearColor];
        _detailTextLabel.textAlignment   = NSTextAlignmentCenter;
        _detailTextLabel.font            = [UIFont systemFontOfSize:10.0f];
        _detailTextLabel.textColor       = [UIColor colorWithRed:164.0/255.0 green:168.0/255.0 blue:171.0/255.0 alpha:1.0];
        _detailTextLabel.shadowColor     = [UIColor colorWithWhite:0.9f alpha:1.0f];
        _detailTextLabel.shadowOffset    = CGSizeMake(0.0f, 1.0f);
    }
    return _detailTextLabel;
}

- (NSDateFormatter *)dateFormatter
{
    if ( _dateFormatter == nil ) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setAMSymbol:@"AM"];
		[_dateFormatter setPMSymbol:@"PM"];
		[_dateFormatter setDateFormat:@"MM-dd HH:mm"];
        [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return _dateFormatter;
}

- (void)setDelegate:(id<CWRefreshTableHeaderDelegate>)delegate
{
    [super setDelegate:delegate];
    
    if ([delegate respondsToSelector:@selector(lxhRefreshTableHeaderDataSourceLastUpdated:)]) {
        NSString *text = [[NSUserDefaults standardUserDefaults] valueForKey:@"lxhRefreshTableView_LastRefresh"];
        if (text) {
            self.detailTextLabel.text = text;
        }
    }
}
@end
