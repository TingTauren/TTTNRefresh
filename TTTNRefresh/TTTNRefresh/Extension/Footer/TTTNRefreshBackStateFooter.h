//
//  TTTNRefreshBackStateFooter.h
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/5.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBackFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTNRefreshBackStateFooter : TTTNRefreshBackFooter

/** 显示刷新状态的label */
@property (nonatomic, readonly) UILabel *stateLabel;
/// 设置state状态下的文字
- (void)tttn_setTitle:(NSString *)title forState:(TTTNRefreshState)state;
/// 获取状态下的文字
- (NSString *)tttn_titleForState:(TTTNRefreshState)state;

@end

NS_ASSUME_NONNULL_END
