//
//  TTTNRefreshAutoNormalHeader.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/9.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshAutoNormalHeader.h"

@interface TTTNRefreshAutoNormalHeader()
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@end

@implementation TTTNRefreshAutoNormalHeader

#pragma mark ----- set get
- (UIActivityIndicatorView *)loadingView {
    if (_loadingView) return _loadingView;
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
    _loadingView.hidesWhenStopped = YES;
    [self addSubview:_loadingView];
    return _loadingView;
}
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}
- (void)setState:(TTTNRefreshState)state {
    TTTNRefreshCheckState
    
    // 根据状态做事情
    if (state == TTTNRefreshStateNoMoreData || state == TTTNRefreshStateIdle) {
        [self.loadingView stopAnimating];
    } else if (state == TTTNRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
}

#pragma mark ----- init Methods

#pragma mark ----- Override Methods
/// 准备方法
- (void)tttn_prepare {
    [super tttn_prepare];
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}
/// 摆放控件的位置
- (void)tttn_placeSubviewsFrame {
    [super tttn_placeSubviewsFrame];
    if (self.loadingView.constraints.count) return;
    
    // 圈圈
    CGFloat loadingCenterX = self.tttn_w * 0.5;
    CGFloat loadingCenterY = self.tttn_h * 0.5;
    if (!self.isRefreshingTitleHidden) {
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            loadingCenterY -= self.stateLabel.tttn_textHeight * 0.5 + self.labelLeftInset;
        }
        else {
            loadingCenterX -= self.stateLabel.tttn_textWith * 0.5 + self.labelLeftInset;
        }
    }
    
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods

@end
