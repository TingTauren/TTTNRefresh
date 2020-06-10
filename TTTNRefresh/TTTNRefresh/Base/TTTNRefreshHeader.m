//
//  TTTNRefreshHeader.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/3.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshHeader.h"

const CGFloat TTTNRefreshHeaderContentSize =
54.0;

@implementation TTTNRefreshHeader

#pragma mark ----- set get

#pragma mark ----- Class Methods
/// 创建header
+ (instancetype)headerWithRefreshingBlock:(dispatch_block_t)refreshingBlock {
    TTTNRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
/// 创建header
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    TTTNRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target regreshingAction:action];
    return cmp;
}

#pragma mark ----- init Methods
/// 当视图即将从父视图移除时调用
/// @param newWindow 为空就表示移除
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (!newWindow && self.isRefreshing) {
        [self endRefreshing];
    }
}

#pragma mark ----- Override Methods
/// 准备方法
- (void)tttn_prepare {
    [super tttn_prepare];
    // 设置头视图内容大小
    if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
        self.tttn_h = TTTNRefreshHeaderContentSize;
    }
    else {
        self.tttn_w = TTTNRefreshHeaderContentSize;
    }
    
    // 设置key
    self.lastUpdatedTimeKey = TTTNRefreshHeaderLastUpdatedTimeKey;
}
/// 摆放子控件frame
- (void)tttn_placeSubviewsFrame {
    [super tttn_placeSubviewsFrame];
    // 设置头视图位置 和大小
    if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
        // 设置大小
        self.tttn_h = TTTNRefreshHeaderContentSize;
    }
    else {
        // 设置大小
        self.tttn_w = TTTNRefreshHeaderContentSize;
    }
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods

@end
