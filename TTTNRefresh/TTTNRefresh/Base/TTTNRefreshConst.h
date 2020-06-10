//
//  TTTNRefreshConst.h
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/4.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

// RGB颜色
#define TTTNRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define TTTNRefreshLabelTextColor TTTNRefreshColor(90, 90, 90)

// 字体大小
#define TTTNRefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 常量
extern NSString *const TTTNRefreshHeaderLastUpdatedTimeKey;

// 状态默认值
extern NSString *const TTTNRefreshHeaderIdleText;
extern NSString *const TTTNRefreshHeaderPullingText;
extern NSString *const TTTNRefreshHeaderRefreshingText;

extern NSString *const TTTNRefreshAutoFooterIdleText;
extern NSString *const TTTNRefreshAutoFooterRefreshingText;
extern NSString *const TTTNRefreshAutoFooterNoMoreDataText;

extern NSString *const TTTNRefreshBackFooterIdleText;
extern NSString *const TTTNRefreshBackFooterPullingText;
extern NSString *const TTTNRefreshBackFooterRefreshingText;
extern NSString *const TTTNRefreshBackFooterNoMoreDataText;

extern NSString *const TTTNRefreshHeaderLastTimeText;
extern NSString *const TTTNRefreshHeaderDateTodayText;
extern NSString *const TTTNRefreshHeaderNoneLastDateText;

// 状态检查
#define TTTNRefreshCheckState \
TTTNRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
