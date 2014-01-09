//
//  LTCRefreshTableHeaderView.h
//  CWTableViewPullRefresh
//
//  Created by ly on 14-1-8.
//  Copyright (c) 2014年 ly. All rights reserved.
//

#import "CWRefreshTableHeaderView.h"

@interface LTCRefreshTableHeaderView : CWRefreshTableHeaderView

@property (strong, nonatomic, readonly) UILabel *textLabel;

@property (strong, nonatomic, readonly) UIImageView *animationView;

@property (strong, nonatomic, readonly) UIImageView *placeholderView;

@property (strong, nonatomic, readonly) NSArray *animationImages;

- (id)initWithAnimationImages:(NSArray *)images;

@end
