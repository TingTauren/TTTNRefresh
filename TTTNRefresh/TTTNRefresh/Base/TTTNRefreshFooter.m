//
//  TTTNRefreshFooter.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/3.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshFooter.h"

const CGFloat TTTNRefreshFooterContentSize =
44.0;

@implementation TTTNRefreshFooter

#pragma mark ----- set get

#pragma mark ----- Class Methods
/// 创建footer
+ (instancetype)footerWithRefreshingBlock:(dispatch_block_t)refreshingBlock {
    TTTNRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
/// 创建header
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    TTTNRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target regreshingAction:action];
    return cmp;
}

#pragma mark ----- init Methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark ----- Override Methods
/// 准备方法
- (void)tttn_prepare {
    [super tttn_prepare];
    // 设置头视图内容大小
    if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
        self.tttn_h = TTTNRefreshFooterContentSize;
    }
    else {
        self.tttn_w = TTTNRefreshFooterContentSize;
    }
}
/// 摆放子控件frame
- (void)tttn_placeSubviewsFrame {
    [super tttn_placeSubviewsFrame];
    // 设置头视图内容大小
    if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
        self.tttn_h = TTTNRefreshFooterContentSize;
    }
    else {
        self.tttn_w = TTTNRefreshFooterContentSize;
    }
}
/// 当视图即将加入父视图时 / 当视图即将从父视图移除时调用
/// @param newSuperview 为空就表示移除
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self scrollViewContentSizeDidChange:nil];
}
/// 当scrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange:(NSDictionary * _Nullable)change {
    [super scrollViewContentSizeDidChange:change];
    
    // 内容的大小
    CGFloat contentSize = self.scrollView.tttn_contentH + self.ignoredScrollViewContentInsetMargin;
    // 表格的大小
    CGFloat scrollSize = self.scrollView.tttn_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetMargin;
    // 设置头视图内容大小
    if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
        // 设置位置和尺寸
        self.tttn_y = MAX(contentSize, scrollSize);
    }
    else {
        contentSize = self.scrollView.tttn_contentW + self.ignoredScrollViewContentInsetMargin;
        scrollSize = self.scrollView.tttn_w - self.scrollViewOriginalInset.left - self.scrollViewOriginalInset.right + self.ignoredScrollViewContentInsetMargin;
        // 设置位置和尺寸
        self.tttn_x = MAX(contentSize, scrollSize);
    }
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods
/// 提示没有更多的数据
- (void)endRefreshingWithNoMoreData {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 设置状态为没有更多数据
        self.state = TTTNRefreshStateNoMoreData;
    });
}
/// 重置没有更多的数据(消除没有更多数据的状态)
- (void)resetNoMoreData {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 设置状态为普通闲置状态
        self.state = TTTNRefreshStateIdle;
    });
}

@end
