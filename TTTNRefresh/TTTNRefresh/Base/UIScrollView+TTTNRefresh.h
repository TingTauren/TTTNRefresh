//
//  UIScrollView+TTTNRefresh.h
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/2.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTTNRefreshBaseView;
@interface UIScrollView (TTTNRefresh)

/** 头部刷新视图 */
@property (nonatomic, strong) TTTNRefreshBaseView *tttn_headerRefresh;
/** 尾部刷新视图 */
@property (nonatomic, strong) TTTNRefreshBaseView *tttn_footerRefresh;

#pragma mark ----- other
/// 获取列表数量
- (NSInteger)tttn_totalDataCount;

#pragma mark ----- 快捷属性操作
/** 边距 */
@property (nonatomic, readonly) UIEdgeInsets tttn_inset;
/** 上边距 */
@property (nonatomic, assign) CGFloat tttn_insetT;
/** 下边距 */
@property (nonatomic, assign) CGFloat tttn_insetB;
/** 左边距 */
@property (nonatomic, assign) CGFloat tttn_insetL;
/** 右边距 */
@property (nonatomic, assign) CGFloat tttn_insetR;
/** 内容偏移X */
@property (nonatomic, assign) CGFloat tttn_offsetX;
/** 内容偏移Y */
@property (nonatomic, assign) CGFloat tttn_offsetY;
/** 内容宽度 */
@property (nonatomic, assign) CGFloat tttn_contentW;
/** 内容高度 */
@property (nonatomic, assign) CGFloat tttn_contentH;

@end

NS_ASSUME_NONNULL_END
