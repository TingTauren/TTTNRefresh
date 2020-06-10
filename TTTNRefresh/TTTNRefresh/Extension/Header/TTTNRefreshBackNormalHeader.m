//
//  TTTNRefreshNormalHeader.m
//  TTTNTestCalendar
//
//  Created by TingTauren on 2020/6/6.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBackNormalHeader.h"

@interface TTTNRefreshBackNormalHeader()
/** 箭头图标 */
@property (nonatomic, readwrite) UIImageView *arrowView;
/** 菊花视图 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@end

@implementation TTTNRefreshBackNormalHeader

#pragma mark ----- set get
- (UIImageView *)arrowView {
    if (_arrowView) return _arrowView;
    _arrowView = [[UIImageView alloc] init];
    _arrowView.image = [self tttn_getArrowImage];
    [self addSubview:_arrowView];
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
- (void)setState:(TTTNRefreshState)state {
    TTTNRefreshCheckState
    
    // 根据状态做事情
    if (state == TTTNRefreshStateIdle) { // 普通状态
        if (oldState == TTTNRefreshStateRefreshing) { // 刷新中
            self.arrowView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:TTTNRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != TTTNRefreshStateIdle) return;
                // 显示菊花图标
                self.loadingView.alpha = 1.0;
                // 停止旋转
                [self.loadingView stopAnimating];
                // 显示箭头图标
                self.arrowView.hidden = NO;
            }];
        }
        else {
            // 停止旋转
            [self.loadingView stopAnimating];
            // 显示箭头图标
            self.arrowView.hidden = NO;
            // 还原形变参数
            [UIView animateWithDuration:TTTNRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    }
    else if (state == TTTNRefreshStatePulling) { // 松开就可以进行刷新状态
        // 停止旋转
        [self.loadingView stopAnimating];
        // 显示箭头图标
        self.arrowView.hidden = NO;
        // 旋转箭头图标
        [UIView animateWithDuration:TTTNRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    }
    else if (state == TTTNRefreshStateRefreshing) { // 正在刷新中的状态
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        // 旋转菊花
        [self.loadingView startAnimating];
        // 隐藏箭头图标
        self.arrowView.hidden = YES;
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
        CGFloat timeSize = 0.0;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            stateSize = self.stateLabel.tttn_textHeight;
        }
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeSize = self.lastUpdatedTimeLabel.tttn_textWith;
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                timeSize = self.lastUpdatedTimeLabel.tttn_textHeight;
            }
        }
        CGFloat textSize = MAX(stateSize, timeSize);
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            arrowCenterY -= textSize / 2 + self.labelLeftInset;
        }
        else {
            arrowCenterX -= textSize / 2 + self.labelLeftInset;
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
