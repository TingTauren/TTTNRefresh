//
//  TTTNRefreshHeader.h
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/3.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBaseView.h"

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat TTTNRefreshHeaderContentSize;

@interface TTTNRefreshHeader : TTTNRefreshBaseView

/// 创建header
+ (instancetype)headerWithRefreshingBlock:(dispatch_block_t)refreshingBlock;
/// 创建header
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 这个key用来存储上一次下拉刷新成功的时间 */
@property (copy, nonatomic) NSString *lastUpdatedTimeKey;
/** 上一次下拉刷新成功的时间 */
@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;

/** 忽略多少scrollView的contentInset的边距 */
@property (nonatomic, assign) CGFloat ignoredScrollViewContentInsetMargin;

@end

NS_ASSUME_NONNULL_END
