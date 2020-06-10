//
//  TTTNRefreshAutoFooter.h
//  TTTNTestCalendar
//
//  Created by TingTauren on 2020/6/7.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshFooter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTNRefreshAutoFooter : TTTNRefreshFooter

/** 是否自动刷新(默认为YES) */
@property (nonatomic, assign, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

/** 是否每一次拖拽只发一次请求 */
@property (nonatomic, assign, getter=isOnlyRefreshPerDrag) BOOL onlyRefreshPerDrag;

/** 是否显示出视图 */
@property (nonatomic, assign) BOOL isShow;

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;
/** 偏移多少判断触发条件 */
@property (nonatomic, assign) CGFloat offsetSize;

@end

NS_ASSUME_NONNULL_END
