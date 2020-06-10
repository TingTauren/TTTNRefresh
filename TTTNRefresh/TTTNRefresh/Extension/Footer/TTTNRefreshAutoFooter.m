//
//  TTTNRefreshAutoFooter.m
//  TTTNTestCalendar
//
//  Created by TingTauren on 2020/6/7.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshAutoFooter.h"

@interface TTTNRefreshAutoFooter()
/** 一个新的拖拽 */
@property (nonatomic, assign, getter=isOneNewPan) BOOL oneNewPan;
@end

@implementation TTTNRefreshAutoFooter

#pragma mark ----- set get
- (void)setHidden:(BOOL)hidden {
    BOOL lastHidden = self.isHidden;
    [super setHidden:hidden];
    if (!lastHidden && hidden) {
        // 从显示变成隐藏
        self.state = TTTNRefreshStateIdle;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.scrollView.tttn_insetR -= self.tttn_w;
        }
        else {
            self.scrollView.tttn_insetB -= self.tttn_h;
        }
    }
    else if (lastHidden && !hidden) {
        // 从隐藏变成显示
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.scrollView.tttn_insetR += self.tttn_w;
            // 设置位置
            self.tttn_x = _scrollView.tttn_contentW;
        }
        else {
            self.scrollView.tttn_insetB += self.tttn_h;
            // 设置位置
            self.tttn_y = _scrollView.tttn_contentH;
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
                CGFloat size = fmax(self.tttn_w, TTTNRefreshFooterContentSize);
                self.scrollView.tttn_insetR += (self.isShow ? size : 0.0);
            } else {
                CGFloat size = fmax(self.tttn_h, TTTNRefreshFooterContentSize);
                self.scrollView.tttn_insetB += (self.isShow ? size : 0.0);
            }
        }
        // 设置位置
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            CGFloat offsetSize = _scrollView.tttn_contentW;
            CGFloat size = fmax(self.tttn_w, TTTNRefreshFooterContentSize);
//            offsetSize = fmax(_scrollView.tttn_w + _scrollViewOriginalInset.left + _scrollViewOriginalInset.right - size - _scrollView.tttn_insetL, offsetSize);
            offsetSize = fmax(_scrollView.tttn_w - size - _scrollViewOriginalInset.left, offsetSize);
            self.tttn_x = offsetSize;
        } else {
            CGFloat offsetSize = _scrollView.tttn_contentH;
            CGFloat size = fmax(self.tttn_h, TTTNRefreshFooterContentSize);
            offsetSize = fmax(_scrollView.tttn_h - size - _scrollViewOriginalInset.top, offsetSize);
            self.tttn_y = offsetSize;
        }
    }
    else { // 被移除了
        if (self.hidden == NO) {
            // 移除自身高度的边距
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                self.scrollView.tttn_insetR -= (self.isShow ? self.tttn_w : 0.0);
            } else {
                self.scrollView.tttn_insetB -= (self.isShow ? self.tttn_h : 0.0);
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
    
    self.offsetSize = 0.0;
}
/// 摆放子控件frame
- (void)tttn_placeSubviewsFrame {
    if (self.scrollView.isDragging) return;
    [super tttn_placeSubviewsFrame];
}
/// 当scrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    
    // 设置位置
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        self.tttn_x = self.scrollView.tttn_contentW;
    }
    else {
        self.tttn_y = self.scrollView.tttn_contentH;
    }
}
/// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
    CGFloat minSize = self.tttn_y;
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        minSize = self.tttn_x;
    }
    if (self.state != TTTNRefreshStateIdle || !self.automaticallyRefresh || minSize == 0 || self.state == TTTNRefreshStateNoMoreData) return;
    
    CGFloat maxSize = _scrollView.tttn_contentH + _scrollView.tttn_insetB;
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        maxSize = _scrollView.tttn_contentW + _scrollView.tttn_insetR;
    }
    BOOL checkMax = (_scrollView.tttn_insetT + maxSize >= _scrollView.tttn_h);
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        checkMax = (_scrollView.tttn_insetL + maxSize >= _scrollView.tttn_w);
    }
    if (checkMax) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        // 触发边距
        CGFloat triggerMargin = maxSize - _scrollView.tttn_h + self.tttn_h*self.triggerAutomaticallyRefreshPercent - self.tttn_h + _scrollView.tttn_insetB + self.offsetSize + (_isShow ? -self.tttn_h : self.tttn_h);
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            triggerMargin = maxSize - _scrollView.tttn_w + self.tttn_w*self.triggerAutomaticallyRefreshPercent - self.tttn_w + _scrollView.tttn_insetR + self.offsetSize + (_isShow ? -self.tttn_w : self.tttn_w);
        }
        BOOL checkTrigger = (_scrollView.tttn_offsetY >= triggerMargin);
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            checkTrigger = (_scrollView.tttn_offsetX >= triggerMargin);
        }
        if (checkTrigger) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                if (new.x <= old.x) return;
            }
            else {
                if (new.y <= old.y) return;
            }
            
            if (self.state != TTTNRefreshStateRefreshing) {
                // 当底部刷新控件完全出现时，才刷新
                [self beginRefreshing];
            }
        }
    }
}
/// 当scrollView的拖拽状态发生改变的时候调用
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != TTTNRefreshStateIdle || self.state == TTTNRefreshStateNoMoreData) return;
    
    UIGestureRecognizerState panState = _scrollView.panGestureRecognizer.state;
    if (panState == UIGestureRecognizerStateEnded) { // 手松开
        CGFloat maxSize = _scrollView.tttn_contentH;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            maxSize = _scrollView.tttn_contentW;
        }
        BOOL checkMax = (_scrollView.tttn_insetT + maxSize <= _scrollView.tttn_h);
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            checkMax = (_scrollView.tttn_insetL + maxSize <= _scrollView.tttn_w);
        }
        if (checkMax) { // 不够一个屏幕
            BOOL checkTrigger = (_scrollView.tttn_offsetY >= - _scrollView.tttn_insetT - self.offsetSize + (_isShow ? 0.0 : self.tttn_h));
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                checkTrigger = (_scrollView.tttn_offsetX >= - _scrollView.tttn_insetL - self.offsetSize + (_isShow ? 0.0 : self.tttn_w));
            }
            if (checkTrigger) { // 向上拽
                [self beginRefreshing];
            }
        }
        else { // 超出一个屏幕
            // 触发边距
            CGFloat triggerMargin = maxSize - _scrollView.tttn_h + self.tttn_h*self.triggerAutomaticallyRefreshPercent - self.tttn_h + _scrollView.tttn_insetB + self.offsetSize + (_isShow ? -self.tttn_h : self.tttn_h);
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                triggerMargin = maxSize - _scrollView.tttn_w + self.tttn_w*self.triggerAutomaticallyRefreshPercent - self.tttn_w + _scrollView.tttn_insetR + self.offsetSize + (_isShow ? -self.tttn_w : self.tttn_w);
            }
            BOOL checkTrigger = (_scrollView.tttn_offsetY >= triggerMargin);
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                checkTrigger = (_scrollView.tttn_offsetX >= triggerMargin);
            }
            if (checkTrigger) {
                [self beginRefreshing];
            }
        }
    }
    else if (panState == UIGestureRecognizerStateBegan) {
        self.oneNewPan = YES;
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
