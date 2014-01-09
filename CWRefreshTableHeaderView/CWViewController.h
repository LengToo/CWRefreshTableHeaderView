//
//  CWViewController.h
//  CWTableViewPullRefresh
//
//  Created by ly on 14-1-8.
//  Copyright (c) 2014年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCRefreshTableHeaderView.h"
#import "LXHRefreshTableHeaderView.h"

#define RefreshHeaderType       1

@interface CWViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CWRefreshTableHeaderDelegate>

#if RefreshHeaderType == 0
@property (strong, nonatomic) LTCRefreshTableHeaderView *refreshHeaderView;
#elif RefreshHeaderType == 1
@property (strong, nonatomic) LXHRefreshTableHeaderView *refreshHeaderView;
#endif

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
