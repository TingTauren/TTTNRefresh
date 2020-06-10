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

/*
 # TTTNRefresh
 滚动视图拉动刷新

 因为项目中需要一些刷新效果(横向自动刷新)，本来项目中就用的MJRefresh,然后就想为什么MJRefresh没有</br>
 基于这样的情况下,照着MJRefresh的源码重新手写一遍,了解了大致原理，然后扩展了一些属性和效果</br>
 </br>
 1、扩展了横向滑动属性，支持横向滚动下拉刷新和上拉加载更多</br>
 </br>
 2、扩展了一个吸顶效果的下拉刷新和上拉加载更多，只需要一个属性开关设置就好</ber>
   需要这样效果的小伙伴也可以使用MJRefresh直接扩展一个这样的效果，关键代码在TTTNRefreshBackStateHeader文件和TTTNRefreshBackStateFooter文件的方
   法‘scrollViewContentOffsetDidChange中’</bar>
 </br>
 3、扩展头部自动刷新类，MJRefresh只有Footer有自动刷新的方法</br>
 </br>
 使用方法和MJRefersh一模一样</br>
 MJRefresh源码地址https://github.com/CoderMJLee/MJRefresh
 */

#pragma mark ----- 状态相关
/** 显示刷新状态的label */
@property (nonatomic, readonly) UILabel *stateLabel;
/// 设置state状态下的文字
- (void)tttn_setTitle:(NSString *)title forState:(TTTNRefreshState)state;

@end

NS_ASSUME_NONNULL_END
