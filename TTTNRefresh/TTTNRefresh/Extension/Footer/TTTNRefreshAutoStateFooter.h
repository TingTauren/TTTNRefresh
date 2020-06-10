//
//  TTTNRefreshAutoStateFooter.h
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/8.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshAutoFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTNRefreshAutoStateFooter : TTTNRefreshAutoFooter

/** 显示刷新状态的label */
@property (nonatomic, readonly) UILabel *stateLabel;

/** 隐藏刷新状态的文字 */
@property (nonatomic, assign, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;

/** 设置state状态下的文字 */
- (void)tttn_setTitle:(NSString *)title forState:(TTTNRefreshState)state;

@end

NS_ASSUME_NONNULL_END
