//
//  TTTNRefreshBackNormalFooter.m
//  TTTNTestCalendar
//
//  Created by TingTauren on 2020/6/6.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBackNormalFooter.h"

@interface TTTNRefreshBackNormalFooter()
/** 箭头图标 */
@property (nonatomic, readwrite) UIImageView *arrowView;
/** 菊花视图 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@end

@implementation TTTNRefreshBackNormalFooter

#pragma mark ----- set get
- (UIImageView *)arrowView {
    if (_arrowView) return _arrowView;
    _arrowView = [[UIImageView alloc] init];
    _arrowView.image = [self tttn_getArrowImage:(self.tttn_direction == TTTNRefreshScrollDirectionHorizontal)];
    [self addSubview:_arrowView];
    _arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
    return _arrowView;
}
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
- (void)setTttn_direction:(TTTNRefreshScrollDirection)tttn_direction {
    [super setTttn_direction:tttn_direction];
    _arrowView.image = [self tttn_getArrowImage:(self.tttn_direction == TTTNRefreshScrollDirectionHorizontal)];
}
- (void)setState:(TTTNRefreshState)state {
    TTTNRefreshCheckState
    
    // 根据状态做事情
    if (state == TTTNRefreshStateIdle) {
        if (oldState == TTTNRefreshStateRefreshing) { // 正在刷新中
            // 旋转箭头
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            [UIView animateWithDuration:TTTNRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 防止动画结束后，状态已经不是MJRefreshStateIdle
                if (state != TTTNRefreshStateIdle) return;
                self.loadingView.alpha = 1.0;
                // 停止旋转
                [self.loadingView stopAnimating];
                // 显示箭头图标
                self.arrowView.hidden = NO;
            }];
        }
        else {
            // 显示箭头图标
            self.arrowView.hidden = NO;
            // 停止旋转
            [self.loadingView stopAnimating];
            // 旋转箭头图标
            [UIView animateWithDuration:TTTNRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }
    }
    else if (state == TTTNRefreshStatePulling) { // 松开即将刷新状态
        // 显示箭头图标
        self.arrowView.hidden = NO;
        // 停止菊花转动
        [self.loadingView stopAnimating];
        // 还原形变
        [UIView animateWithDuration:TTTNRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformIdentity;
        }];
    }
    else if (state == TTTNRefreshStateRefreshing) { // 刷新中
        // 隐藏箭头图标
        self.arrowView.hidden = YES;
        // 开始旋转菊花
        [self.loadingView startAnimating];
    }
    else if (state == TTTNRefreshStateNoMoreData) { // 没有更多数据状态
        // 隐藏箭头图标
        self.arrowView.hidden = YES;
        // 停止旋转菊花
        [self.loadingView stopAnimating];
    }
}

#pragma mark ----- init Methods

#pragma mark ----- Override Methods
/// 准备方法
- (void)tttn_prepare {
    [super tttn_prepare];
    // 初始化菊花
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    // 边距
    self.labelLeftInset = 25.0;
}
/// 摆放控件的位置
- (void)tttn_placeSubviewsFrame {
    [super tttn_placeSubviewsFrame];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.tttn_w * 0.5;
    CGFloat arrowCenterY = self.tttn_h * 0.5;
    if (!self.stateLabel.hidden) {
        CGFloat stateSize = self.stateLabel.tttn_textWith;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            stateSize = self.stateLabel.tttn_textHeight;
        }
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            arrowCenterY -= stateSize / 2 + self.labelLeftInset;
        }
        else {
            arrowCenterX -= stateSize / 2 + self.labelLeftInset;
        }
    }
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.tttn_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    self.arrowView.tintColor = self.stateLabel.textColor;
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods

@end
