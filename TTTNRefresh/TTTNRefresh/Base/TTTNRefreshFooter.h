//
//  TTTNRefreshFooter.h
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/3.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBaseView.h"

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat TTTNRefreshFooterContentSize;

@interface TTTNRefreshFooter : TTTNRefreshBaseView

/// 创建footer
+ (instancetype)footerWithRefreshingBlock:(dispatch_block_t)refreshingBlock;
/// 创建header
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 忽略多少scrollView的contentInset的边距 */
@property (nonatomic, assign) CGFloat ignoredScrollViewContentInsetMargin;

/// 提示没有更多的数据
- (void)endRefreshingWithNoMoreData;
/// 重置没有更多的数据(消除没有更多数据的状态)
- (void)resetNoMoreData;

@end

NS_ASSUME_NONNULL_END
