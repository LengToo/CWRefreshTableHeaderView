//
//  LXHRefreshTableHeaderView.h
//  CWTableViewPullRefresh
//
//  Created by ly on 14-1-8.
//  Copyright (c) 2014年 ly. All rights reserved.
//

#import "CWRefreshTableHeaderView.h"

@interface LXHRefreshTableHeaderView : CWRefreshTableHeaderView

@property (strong, nonatomic) UILabel *textLabel;

@property (strong, nonatomic) UILabel *detailTextLabel;

@property (strong, nonatomic, readonly) UIImageView *placeholderView;

@property (strong, nonatomic, readonly) UIImageView *animationImageView;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

- (id)initWithPlaceholder:(UIImage *)placeholder animationImage:(UIImage *)animationImage;

@end

@protocol LXHRefreshTableHeaderDelegate <CWRefreshTableHeaderDelegate>
- (NSDate*)lxhRefreshTableHeaderDataSourceLastUpdated:(CWRefreshTableHeaderView*)view;
@end
