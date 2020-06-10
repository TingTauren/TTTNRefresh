//
//  TTTNRefreshAutoHeader.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/8.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshAutoHeader.h"

@interface TTTNRefreshAutoHeader()
/** 一个新的拖拽 */
@property (nonatomic, assign, getter=isOneNewPan) BOOL oneNewPan;
/** 记录手势开始时的位置 */
@property (nonatomic, assign) CGPoint panBeginPoint;
@end

@implementation TTTNRefreshAutoHeader

#pragma mark ----- set get
- (void)setHidden:(BOOL)hidden {
    BOOL lastHidden = self.isHidden;
    [super setHidden:hidden];
    if (!lastHidden && hidden) {
        // 从显示变成隐藏
        self.state = TTTNRefreshStateIdle;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.scrollView.tttn_insetL -= self.tttn_w;
        }
        else {
            self.scrollView.tttn_insetT -= self.tttn_h;
        }
    }
    else if (lastHidden && !hidden) {
        // 从隐藏变成显示
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.scrollView.tttn_insetL += self.tttn_w;
            // 设置位置
            self.tttn_x = (self.isShow ? 0.0 : -self.tttn_w);
        }
        else {
            self.scrollView.tttn_insetT += self.tttn_h;
            // 设置位置
            self.tttn_y = (self.isShow ? 0.0 : -self.tttn_h);
        }
    }
}
- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
}
- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha {
    [super setAutomaticallyChangeAlpha:automaticallyChangeAlpha];
    self.alpha = 1.0;
}
- (void)setState:(TTTNRefreshState)state {
    TTTNRefreshCheckState
    
    if (state == TTTNRefreshStateRefreshing) {
        [self tttn_executeRefreshingCallback];
    }
    else if (state == TTTNRefreshStateNoMoreData || state == TTTNRefreshStateIdle) {
        if (TTTNRefreshStateRefreshing == oldState) {
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }
}

#pragma mark ----- init Methods

#pragma mark ----- Override Methods
/// 当视图即将加入父视图时 / 当视图即将从父视图移除时调用
/// @param newSuperview 为空就表示移除
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            // 增加自身高度的边距
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                CGFloat size = fmax(self.tttn_w, TTTNRefreshHeaderContentSize);
                self.scrollView.tttn_insetL += (self.isShow ? size : 0.0);
            } else {
                CGFloat size = fmax(self.tttn_h, TTTNRefreshHeaderContentSize);
                self.scrollView.tttn_insetT += (self.isShow ? size : 0.0);
            }
        }
        // 设置位置
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.tttn_x = 0.0;
            CGFloat size = self.scrollView.tttn_insetL-self.scrollViewOriginalInset.left;
            [self.scrollView setContentOffset:CGPointMake(-size, 0.0) animated:NO];
        } else {
            self.tttn_y = 0.0;
            CGFloat size = self.scrollView.tttn_insetT-self.scrollViewOriginalInset.top;
            [self.scrollView setContentOffset:CGPointMake(0.0, -size) animated:NO];
        }
    }
    else { // 被移除了
        if (self.hidden == NO) {
            // 移除自身高度的边距
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                self.scrollView.tttn_insetL -= (self.isShow ? self.tttn_w : 0.0);
            } else {
                self.scrollView.tttn_insetT -= (self.isShow ? self.tttn_h : 0.0);
            }
        }
    }
}
/// 准备方法
- (void)tttn_prepare {
    [super tttn_prepare];
    // 设置为默认状态
    self.automaticallyRefresh = YES;
    // 默认是当offset达到条件就发送请求（可连续）
    self.onlyRefreshPerDrag = NO;
    // 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新)
    self.triggerAutomaticallyRefreshPercent = 1.0;
    // 是否显示出视图
    self.isShow = YES;
    // 偏移多少判断触发条件
    self.offsetSize = 0.0;
}
/// 摆放子控件frame
- (void)tttn_placeSubviewsFrame {
    if (self.scrollView.isDragging) return;
    [super tttn_placeSubviewsFrame];
    
    // 设置位置
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        self.tttn_x = (self.isShow ? -self.scrollView.tttn_insetL : -self.tttn_w);
    } else {
        self.tttn_y = (self.isShow ? -self.scrollView.tttn_insetT : -self.tttn_h);
    }
}
/// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
    CGFloat minSize = self.tttn_y;
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        minSize = self.tttn_x;
    }
    if (self.state != TTTNRefreshStateIdle || !self.automaticallyRefresh) return;
    
    // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
    // 触发边距
    CGFloat triggerMargin = - self.tttn_h*self.triggerAutomaticallyRefreshPercent + self.tttn_h - _scrollView.tttn_insetT + self.offsetSize + (_isShow ? 0.0 : -self.tttn_h);
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        triggerMargin = - self.tttn_w*self.triggerAutomaticallyRefreshPercent + self.tttn_w - _scrollView.tttn_insetL + self.offsetSize + (_isShow ? 0.0 : -self.tttn_w);
    }
    BOOL checkTrigger = (_scrollView.tttn_offsetY <= triggerMargin);
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        checkTrigger = (_scrollView.tttn_offsetX <= triggerMargin);
    }
    if (checkTrigger) {
        // 防止手松开时连续调用
        CGPoint old = [change[@"old"] CGPointValue];
        CGPoint new = [change[@"new"] CGPointValue];
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            if (new.x >= old.x) return;
            if (new.x >= _panBeginPoint.x) return;
        }
        else {
            if (new.y >= old.y) return;
            if (new.y >= _panBeginPoint.y) return;
        }
        
        if (self.state != TTTNRefreshStateRefreshing) {
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}
/// 当scrollView的拖拽状态发生改变的时候调用
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != TTTNRefreshStateIdle) return;
    
    UIGestureRecognizerState panState = _scrollView.panGestureRecognizer.state;
    if (panState == UIGestureRecognizerStateEnded) { // 手松开
        CGFloat triggerMargin = - self.tttn_h*self.triggerAutomaticallyRefreshPercent + self.tttn_h - _scrollView.tttn_insetT + self.offsetSize + (_isShow ? 0.0 : -self.tttn_h);
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            triggerMargin = - self.tttn_w*self.triggerAutomaticallyRefreshPercent + self.tttn_w - _scrollView.tttn_insetL + self.offsetSize + (_isShow ? 0.0 : -self.tttn_w);
        }
        BOOL checkTrigger = (_scrollView.tttn_offsetY <= triggerMargin);
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            checkTrigger = (_scrollView.tttn_offsetX <= triggerMargin);
        }
        if (checkTrigger) {
            [self beginRefreshing];
        }
    }
    else if (panState == UIGestureRecognizerStateBegan) {
        self.oneNewPan = YES;
        self.panBeginPoint = CGPointMake(_scrollView.tttn_offsetX, _scrollView.tttn_offsetY);
    }
}
/// 进入刷新状态
- (void)beginRefreshing {
    if (!self.isOneNewPan && self.isOnlyRefreshPerDrag) return;
    [super beginRefreshing];
    
    self.oneNewPan = NO;
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods

@end
