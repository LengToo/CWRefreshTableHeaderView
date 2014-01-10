//
//  CWRefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CWRefreshTableHeaderView.h"

#define BaseThreshold       65.0
#define HeaderViewOffset    60.0

@interface CWRefreshTableHeaderView ()
@property (assign, nonatomic) CWPullRefreshState state;
@end

@implementation CWRefreshTableHeaderView

- (id)init
{
    self = [super init];
    if (self) {
        self.originalEdgeInsets = UIEdgeInsetsZero;
        [self setState:CWPullRefreshNormal];
    }
    return self;
}

#pragma mark - Setters

- (void)setState:(CWPullRefreshState)aState
{
	switch (aState) {
		case CWPullRefreshPulling:
            [self onRefreshPulling];
			break;
            
		case CWPullRefreshNormal:
            [self onRefreshNormal];
			break;
            
		case CWPullRefreshLoading:
            [self onRefreshLoading];
			break;
	}
	
	_state = aState;
}


#pragma mark - ScrollView Methods

- (void)cwRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( (scrollView.contentOffset.y + self.originalEdgeInsets.top) > 0 ) {
        return;
    }
    
    if (scrollView.isDragging)
    {
        // Ask delegate is loading
		BOOL _loading = NO;
        if ([self.delegate respondsToSelector:@selector(cwRefreshTableHeaderDataSourceIsLoading:)]) {
            _loading = [self.delegate cwRefreshTableHeaderDataSourceIsLoading:self];
        }
		
        // Toggle pulling or normal state when not loading
        if (!_loading)
        {
            CGFloat threshold = BaseThreshold + abs(self.originalEdgeInsets.top);
            CGFloat offsetY = fabs(scrollView.contentOffset.y);
            
            if (self.state == CWPullRefreshPulling && offsetY < threshold && offsetY > 0.0f)
            {
                [self setState:CWPullRefreshNormal];
            }
            else if (self.state == CWPullRefreshNormal && offsetY > threshold)
            {
                [self setState:CWPullRefreshPulling];
            }
        }
	}
}

- (void)cwRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if ( (scrollView.contentOffset.y + self.originalEdgeInsets.top) > 0 ) {
        return;
    }
    
    // Ask delegate is loading
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(cwRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [self.delegate cwRefreshTableHeaderDataSourceIsLoading:self];
	}
	
    // Triggle reloading
    CGFloat threshold = BaseThreshold + abs(self.originalEdgeInsets.top);
    CGFloat offsetY = fabs(scrollView.contentOffset.y);
    
	if ( !_loading && offsetY >= threshold ) {
		[self cwTriggerReloading:scrollView];
	}
}

- (void)cwTriggerReloading:(UIScrollView *)scrollView
{
    __weak typeof(self) target = self;
    [UIView animateWithDuration:0.25 animations:^{
        
        UIEdgeInsets edgeInsets = target.originalEdgeInsets;
        edgeInsets.top += HeaderViewOffset;
        scrollView.contentInset = edgeInsets;
        [scrollView setContentOffset:CGPointMake(0, -HeaderViewOffset) animated:YES];
        
    } completion:^(BOOL finished) {
        
        [self setState:CWPullRefreshLoading];
        
        if ([self.delegate respondsToSelector:@selector(cwRefreshTableHeaderDidTriggerRefresh:)]) {
            [self.delegate cwRefreshTableHeaderDidTriggerRefresh:self];
        }
    }];
}

- (void)cwRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    __weak UIScrollView *aScrollView = scrollView;
    __weak CWRefreshTableHeaderView *headerView = self;
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        if (headerView.state == CWPullRefreshLoading)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [aScrollView setContentInset:headerView.originalEdgeInsets];
            } completion:^(BOOL finished) {
                [aScrollView setContentOffset:CGPointMake(0, -headerView.originalEdgeInsets.top)];
                [headerView setState:CWPullRefreshNormal];
            }];        }
    });
}


#pragma mark - State

- (void)onRefreshPulling
{
    // Empty
}

- (void)onRefreshNormal
{
    // Empty
}

- (void)onRefreshLoading
{
    // Empty
}

@end
