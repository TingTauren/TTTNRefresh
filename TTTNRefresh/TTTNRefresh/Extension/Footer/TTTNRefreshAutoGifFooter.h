//
//  TTTNRefreshAutoGifFooter.h
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/8.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshAutoStateFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTNRefreshAutoGifFooter : TTTNRefreshAutoStateFooter

/** 动态图片视图 */
@property (nonatomic, readonly) UIImageView *gifView;

/// 设置state状态下的动画图片images 动画持续时间duration
/// @param images 动画图片
/// @param duration 持续时间
/// @param state 状态
- (void)tttn_setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(TTTNRefreshState)state;
/// 设置state状态下的动画图片images
/// @param images 动画图片
/// @param state 状态
- (void)tttn_setImages:(NSArray *)images forState:(TTTNRefreshState)state;

@end

NS_ASSUME_NONNULL_END
