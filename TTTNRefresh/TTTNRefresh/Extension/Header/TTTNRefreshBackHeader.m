//
//  TTTNRefreshBackHeader.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/8.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBackHeader.h"

@interface TTTNRefreshBackHeader()
/** 记录刷新状态偏移的边距 */
@property (nonatomic, assign) CGFloat insetMargin;
@end

@implementation TTTNRefreshBackHeader

#pragma mark ----- set get
- (void)setState:(TTTNRefreshState)state {
    // 检查状态
    TTTNRefreshCheckState
    // 根据状态做事情
    // 普通闲置状态
    if (state == TTTNRefreshStateIdle) {
        if (oldState != TTTNRefreshStateRefreshing) return;
        // 保存刷新时间
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 恢复inset和offset
        [UIView animateWithDuration:TTTNRefreshSlowAnimationDuration animations:^{
            if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
                self.scrollView.tttn_insetT += self.insetMargin;
            }
            else {
                self.scrollView.tttn_insetL += self.insetMargin;
            }
            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            // 设置拉拽的百分比
            self.pullingPercent = 0.0;
            // 调用结束刷新回调
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }];
    }
    // 正在刷新中的状态
    else if (state == TTTNRefreshStateRefreshing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:TTTNRefreshFastAnimationDuration animations:^{
                if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
                    // 增加滚动区域top
                    CGFloat top = self.scrollViewOriginalInset.top + self.tttn_h;
                    // 设置滚动位置
                    CGPoint offset = self.scrollView.contentOffset;
                    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                        top = self.scrollViewOriginalInset.left + self.tttn_w;
                        self.scrollView.tttn_insetL = top;
                        offset.x = -top;
                    }
                    else {
                        self.scrollView.tttn_insetT = top;
                        offset.y = -top;
                    }
                    [self.scrollView setContentOffset:offset animated:NO];
                }
            } completion:^(BOOL finished) {
                // 调用刷新中回调
                [self tttn_executeRefreshingCallback];
            }];
        });
    }
}

#pragma mark ----- init Methods

#pragma mark ----- Override Methods
/// 摆放子控件frame
- (void)tttn_placeSubviewsFrame {
    [super tttn_placeSubviewsFrame];
    
    // 设置头视图位置 和大小
    if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
        // 设置y值
        self.tttn_y = -self.tttn_h - self.ignoredScrollViewContentInsetMargin;
    }
    else {
        // 设置x值
        self.tttn_x = -self.tttn_w - self.ignoredScrollViewContentInsetMargin;
    }
}
/// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    // 正在刷新中的状态
    if (self.state == TTTNRefreshStateRefreshing) {
        // 暂时保留
        if (self.window == nil) return;
        // sectionheader停留解决
        // 根据方向修改值
        if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
            CGFloat insetMargin = - self.scrollView.tttn_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.tttn_offsetY : _scrollViewOriginalInset.top;
            insetMargin = insetMargin > self.tttn_h + _scrollViewOriginalInset.top ? self.tttn_h + _scrollViewOriginalInset.top : insetMargin;
            self.scrollView.tttn_insetT = insetMargin;
            // 记录
            self.insetMargin = _scrollViewOriginalInset.top - insetMargin;
        }
        else {
            CGFloat insetMargin = - self.scrollView.tttn_offsetX > _scrollViewOriginalInset.left ? - self.scrollView.tttn_offsetX : _scrollViewOriginalInset.left;
            insetMargin = insetMargin > self.tttn_w + _scrollViewOriginalInset.left ? self.tttn_w + _scrollViewOriginalInset.left : insetMargin;
            self.scrollView.tttn_insetL = insetMargin;
            // 记录
            self.insetMargin = _scrollViewOriginalInset.left - insetMargin;
        }
        return;
    }
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.tttn_inset;
    
    // 当前的contentOffset
    CGFloat offsetMargin = 0;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetMargin = 0;
    // 根据方向修改值
    if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
        offsetMargin = self.scrollView.tttn_offsetY;
        happenOffsetMargin = - self.scrollViewOriginalInset.top;
    }
    else {
        offsetMargin = self.scrollView.tttn_offsetX;
        happenOffsetMargin = - self.scrollViewOriginalInset.left;
    }
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetMargin > happenOffsetMargin) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetMargin = 0;
    CGFloat pullingPercent = 0;
    // 根据方向修改值
    if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
        normal2pullingOffsetMargin = happenOffsetMargin - self.tttn_h;
        pullingPercent = (happenOffsetMargin - offsetMargin) / self.tttn_h;
    }
    else {
        normal2pullingOffsetMargin = happenOffsetMargin - self.tttn_w;
        pullingPercent = (happenOffsetMargin - offsetMargin) / self.tttn_w;
    }
    
    // 如果正在拖拽
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通闲置状态 && 达到了刷新状态
        if (self.state == TTTNRefreshStateIdle && offsetMargin < normal2pullingOffsetMargin) {
            // 转为即将刷新状态
            self.state = TTTNRefreshStatePulling;
        }
        // 松开就可以进行刷新状态 && 未达到刷新状态
        else if (self.state == TTTNRefreshStatePulling && offsetMargin >= normal2pullingOffsetMargin) {
            // 转为普通状态
            self.state = TTTNRefreshStateIdle;
        }
    }
    // 即将刷新 && 手松开
    else if (self.state == TTTNRefreshStatePulling) {
        // 开始刷新
        [self beginRefreshing];
    }
    // 刷新百分比小于1
    else if (pullingPercent < 1) {
        // 刷新百分比
        self.pullingPercent = pullingPercent;
    }
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods

@end
