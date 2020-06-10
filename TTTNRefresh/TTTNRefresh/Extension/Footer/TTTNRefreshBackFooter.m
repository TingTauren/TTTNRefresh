//
//  TTTNRefreshStateFooter.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/4.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBackFooter.h"

@interface TTTNRefreshBackFooter()
/** 最后刷新数量 */
@property (nonatomic, assign) NSInteger lastRefreshCount;
/** 记录刷新中的边距 */
@property (nonatomic, assign) CGFloat lastBottomMargin;
@end

@implementation TTTNRefreshBackFooter

#pragma mark ----- set get
- (void)setState:(TTTNRefreshState)state {
    TTTNRefreshCheckState
    
    // 根据状态来设置属性
    if (state == TTTNRefreshStateNoMoreData || state == TTTNRefreshStateIdle) {
        // 刷新完毕
        if (TTTNRefreshStateRefreshing == oldState) {
            [UIView animateWithDuration:TTTNRefreshSlowAnimationDuration animations:^{
                if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
                    self.scrollView.tttn_insetB -= self.lastBottomMargin;
                }
                else {
                    self.scrollView.tttn_insetR -= self.lastBottomMargin;
                }
                // 自动调整透明度
                if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
                if (self.endRefreshingCompletionBlock) {
                    self.endRefreshingCompletionBlock();
                }
            }];
        }
        // 获取内容超出高度
        CGFloat margin = [self _tttn_heightForContentBreakView];
        // 刚刷新完毕
        BOOL isCountLast = self.scrollView.tttn_totalDataCount != self.lastRefreshCount; // 数量是否是最后一个
        if (TTTNRefreshStateRefreshing == oldState && margin > 0 && isCountLast) {
            if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
                self.scrollView.tttn_offsetY = self.scrollView.tttn_offsetY;
            }
            else {
                self.scrollView.tttn_offsetX = self.scrollView.tttn_offsetX;
            }
        }
    }
    else if (state == TTTNRefreshStateRefreshing) {
        // 记录刷新前的数量
        self.lastRefreshCount = self.scrollView.tttn_totalDataCount;
        CGFloat animationDuration = (self.isAdsorption ? 0.0 : TTTNRefreshFastAnimationDuration);
        [UIView animateWithDuration:animationDuration animations:^{
            CGFloat refreshSize = self.tttn_h + self.scrollViewOriginalInset.bottom;
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                refreshSize = self.tttn_w + self.scrollViewOriginalInset.right;
            }
            // 获取内容超出高度
            CGFloat margin = [self _tttn_heightForContentBreakView];
            if (margin <= 0) { // 如果内容高度小于view的高度
                refreshSize -= margin;
            }
            // 记录刷新中的边距值
            if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
                self.lastBottomMargin = refreshSize - self.scrollView.tttn_insetB;
                self.scrollView.tttn_insetB = refreshSize;
                CGFloat offsetSize = [self _tttn_happenOffsetSize] + self.tttn_h;
                self.scrollView.tttn_offsetY = offsetSize;
            }
            else {
                self.lastBottomMargin = refreshSize - self.scrollView.tttn_insetR;
                self.scrollView.tttn_insetR = refreshSize;
                CGFloat offsetSize = [self _tttn_happenOffsetSize] + self.tttn_w;
                self.scrollView.tttn_offsetX = offsetSize;
            }
        } completion:^(BOOL finished) {
            // 触发刷新回调
            [self tttn_executeRefreshingCallback];
        }];
    }
}

#pragma mark ----- init Methods

#pragma mark ----- Override Methods
/// 当视图即将加入父视图时 / 当视图即将从父视图移除时调用
/// @param newSuperview 为空就表示移除
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self scrollViewContentSizeDidChange:nil];
}
/// 当scrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange:(NSDictionary *  _Nullable)change {
    [super scrollViewContentSizeDidChange:change];
    // 内容的高度
    CGFloat contentSize = self.scrollView.tttn_contentH + self.ignoredScrollViewContentInsetMargin;
    // 表格的高度
    CGFloat scrollSize = self.scrollView.tttn_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetMargin;
    if (self.isAdsorption) { // 开启了固定效果
        // collectionView改变offset会触发改变ContentSize，这里做了一下偏移
        CGFloat offsetSize = (self.scrollView.tttn_offsetY > 0 ? self.scrollView.tttn_offsetY-self.tttn_h : 0.0);
        scrollSize = scrollSize + offsetSize;
    }
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        contentSize = self.scrollView.tttn_contentW + self.ignoredScrollViewContentInsetMargin;
        scrollSize = self.scrollView.tttn_w - self.scrollViewOriginalInset.left - self.scrollViewOriginalInset.right + self.ignoredScrollViewContentInsetMargin;
        if (self.isAdsorption) { // 开启了固定效果
            // collectionView改变offset会触发改变ContentSize，这里做了一下偏移
            CGFloat offsetSize = (self.scrollView.tttn_offsetX > 0 ? self.scrollView.tttn_offsetX-self.tttn_w : 0.0);
            scrollSize = scrollSize + offsetSize;
        }
        // 设置位置和尺寸
        self.tttn_x = fmax(contentSize, scrollSize);
    }
    else {
        // 设置位置和尺寸
        self.tttn_y = fmax(contentSize, scrollSize);
    }
}
/// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange:(NSDictionary * _Nullable)change {
    [super scrollViewContentOffsetDidChange:change];
    // 如果正在刷新，直接返回
    if (self.state == TTTNRefreshStateRefreshing) return;
    
    // 记录原始边距
    _scrollViewOriginalInset = self.scrollView.tttn_inset;
    
    // 当前的contentOffset
    CGFloat currentOffsetSize = self.scrollView.tttn_offsetY;
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        currentOffsetSize = self.scrollView.tttn_offsetX;
    }
    // 尾部控件刚好出现的offset
    CGFloat happenOffsetSize = [self _tttn_happenOffsetSize];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetSize <= happenOffsetSize) return;
    // 百分比
    CGFloat pullingPercent = (currentOffsetSize - happenOffsetSize) / self.tttn_h;
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        pullingPercent = (currentOffsetSize - happenOffsetSize) / self.tttn_w;
    }
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == TTTNRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetSize = happenOffsetSize + self.tttn_h;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            normal2pullingOffsetSize = happenOffsetSize + self.tttn_w;
        }
        
        if (self.state == TTTNRefreshStateIdle && currentOffsetSize > normal2pullingOffsetSize) {
            // 转为即将刷新状态
            self.state = TTTNRefreshStatePulling;
        } else if (self.state == TTTNRefreshStatePulling && currentOffsetSize <= normal2pullingOffsetSize) {
            // 转为普通状态
            self.state = TTTNRefreshStateIdle;
        }
    } else if (self.state == TTTNRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

#pragma mark ----- Private Methods
/// 获得scrollView的内容 超出 view 的高度
- (CGFloat)_tttn_heightForContentBreakView {
    CGFloat size = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom;
    CGFloat backSize = self.scrollView.contentSize.height - size;
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        size = self.scrollView.frame.size.width - self.scrollViewOriginalInset.right;
        backSize = self.scrollView.contentSize.width - size;
    }
    return backSize;
}
/// 刚好看到上拉刷新控件时的contentOffset
- (CGFloat)_tttn_happenOffsetSize {
    CGFloat margin = [self _tttn_heightForContentBreakView];
    if (margin > 0) {
        CGFloat backSize = margin - self.scrollViewOriginalInset.top;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            backSize = margin - self.scrollViewOriginalInset.left;
        }
        return backSize;
    } else {
        CGFloat backSize = - self.scrollViewOriginalInset.top;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            backSize = - self.scrollViewOriginalInset.left;
        }
        return backSize;
    }
}

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods

@end
