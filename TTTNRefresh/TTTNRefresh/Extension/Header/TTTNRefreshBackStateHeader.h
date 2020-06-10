//
//  TTTNRefreshStateHeader.h
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/4.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBackHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTNRefreshBackStateHeader : TTTNRefreshBackHeader

#pragma mark ----- 刷新时间相关
/** 利用这个block来决定显示的更新时间文字 */
@property (nonatomic, copy) NSString *(^ _Nullable lastUpdatedTimeText)(NSDate *lastUpdatedTime);
/** 显示上一次刷新时间的label */
@property (nonatomic, readonly) UILabel *lastUpdatedTimeLabel;

#pragma mark ----- 状态相关
/** 显示刷新状态的label */
@property (nonatomic, readonly) UILabel *stateLabel;
/// 设置state状态下的文字
- (void)tttn_setTitle:(NSString *)title forState:(TTTNRefreshState)state;

@end

NS_ASSUME_NONNULL_END
