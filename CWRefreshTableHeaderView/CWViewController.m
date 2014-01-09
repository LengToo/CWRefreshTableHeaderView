//
//  CWViewController.m
//  CWTableViewPullRefresh
//
//  Created by ly on 14-1-8.
//  Copyright (c) 2014年 ly. All rights reserved.
//

#import "CWViewController.h"

@interface CWViewController ()

@end

@implementation CWViewController
{
    BOOL isLoading;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView addSubview:self.refreshHeaderView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat width = 0.0;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
        self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        width = CGRectGetWidth(self.view.frame);
    }
    else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
             self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        width = CGRectGetHeight(self.view.frame);
    }
    
    
    self.refreshHeaderView.frame = CGRectMake(0, -300, width, 300);
    [self.refreshHeaderView setNeedsLayout];
}

#pragma mark - Table view datasource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
}


#pragma mark - Scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshHeaderView cwRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshHeaderView cwRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark - Pull to refresh

- (void)cwRefreshTableHeaderDidTriggerRefresh:(CWRefreshTableHeaderView*)view
{
    isLoading = YES;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self stopRefresh];
    });
}

- (BOOL)cwRefreshTableHeaderDataSourceIsLoading:(CWRefreshTableHeaderView*)view
{
    return isLoading;
}

- (NSDate*)lxhRefreshTableHeaderDataSourceLastUpdated:(CWRefreshTableHeaderView*)view
{
    return [NSDate date];
}

- (void)stopRefresh
{
    isLoading = NO;
    [self.refreshHeaderView cwRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}


#pragma mark - Property

#if RefreshHeaderType == 0

- (LTCRefreshTableHeaderView *)refreshHeaderView
{
    if ( _refreshHeaderView == nil ) {
        NSArray *animationImages = @[[UIImage imageNamed:@"pull1"], [UIImage imageNamed:@"pull2"],
                                     [UIImage imageNamed:@"pull3"], [UIImage imageNamed:@"pull4"]];
        _refreshHeaderView = [[LTCRefreshTableHeaderView alloc] initWithAnimationImages:animationImages];
        _refreshHeaderView.delegate = self;
    }
    return _refreshHeaderView;
}

#elif RefreshHeaderType == 1

- (LXHRefreshTableHeaderView *)refreshHeaderView
{
    if ( _refreshHeaderView == nil ) {
        UIImage *placeholder = [UIImage imageNamed:@"pull_refresh_logo"];
        UIImage *animationImage = [UIImage imageNamed:@"fan"];
        _refreshHeaderView = [[LXHRefreshTableHeaderView alloc] initWithPlaceholder:placeholder animationImage:animationImage];
        _refreshHeaderView.delegate = self;
    }
    return _refreshHeaderView;
}

#endif

@end

