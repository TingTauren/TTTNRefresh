//
//  TTTNRefreshBaseView.h
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/2.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIScrollView+TTTNRefresh.h" // 刷新扩展
#import "UIView+TTTNExtension.h" // 视图扩展
#import "NSBundle+TTTNRefresh.h" // 资源扩展
#import "TTTNRefreshConst.h" // 配置文件

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, TTTNRefreshState) {
    /** 普通闲置状态 */
    TTTNRefreshStateIdle,
    /** 松开就可以进行刷新状态 */
    TTTNRefreshStatePulling,
    /** 正在刷新中的状态 */
    TTTNRefreshStateRefreshing,
    /** 即将刷新的状态 */
    TTTNRefreshStateWillRefresh,
    /** 所有数据加载完毕了,没有更多的数据了 */
    TTTNRefreshStateNoMoreData,
};

typedef NS_ENUM(NSInteger, TTTNRefreshScrollDirection) {
    /** 未设置 */
    TTTNRefreshScrollDirectionNormal,
    /** 垂直方向 */
    TTTNRefreshScrollDirectionVertical,
    /** 水平方向 */
    TTTNRefreshScrollDirectionHorizontal
};

NS_ASSUME_NONNULL_BEGIN

// 常量
extern NSString *const TTTNRefreshKeyPathContentOffset;
extern NSString *const TTTNRefreshKeyPathContentInset;
extern NSString *const TTTNRefreshKeyPathContentSize;
extern NSString *const TTTNRefreshKeyPathPanState;

extern const CGFloat TTTNRefreshFastAnimationDuration;
extern const CGFloat TTTNRefreshSlowAnimationDuration;

@interface TTTNRefreshBaseView : UIView {
    /** 记录scrollView刚开始的inset */
    UIEdgeInsets _scrollViewOriginalInset;
    /** 父控件 */
    __weak UIScrollView *_scrollView;
}
#pragma mark ----- 子类访问属性
/** 记录scrollView刚开始的inset */
@property (nonatomic, readonly, assign) UIEdgeInsets scrollViewOriginalInset;
/** 父控件 */
@property (nonatomic, readonly, weak) UIScrollView *scrollView;
/** 刷新状态,一般交给子类内部实现 */
@property (nonatomic, assign) TTTNRefreshState state;

#pragma mark ----- 子类实现方法
/// 准备方法
- (void)tttn_prepare NS_REQUIRES_SUPER;
/// 摆放子控件frame
- (void)tttn_placeSubviewsFrame NS_REQUIRES_SUPER;
/// 当scrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange:(NSDictionary *  _Nullable)change NS_REQUIRES_SUPER;
/// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange:(NSDictionary * _Nullable)change NS_REQUIRES_SUPER;
/// 当scrollView的拖拽状态发生改变的时候调用
- (void)scrollViewPanStateDidChange:(NSDictionary * _Nullable)change NS_REQUIRES_SUPER;

#pragma mark ----- 回调关联
/** 正在刷新的回调 */
@property (nonatomic, copy) dispatch_block_t refreshingBlock;
/// 设置回调对象和方法
- (void)setRefreshingTarget:(id)target regreshingAction:(SEL)action;
/** 回调对象 */
@property (nonatomic, weak) id refreshingTarget;
/** 回调方法 */
@property (nonatomic, assign) SEL refreshingAction;
/// 触发正在刷新的回调(交给子类去调用)
- (void)tttn_executeRefreshingCallback;

#pragma mark ----- 刷新状态控制
/// 进入刷新状态
- (void)beginRefreshing;
/// 设置进入刷新状态回调
- (void)beginRefreshingWithCompletionBlock:(dispatch_block_t)completionBlock;
/** 开始刷新后的回调(进入刷新状态后的回调) */
@property (nonatomic, copy) dispatch_block_t beginRefreshingCompletionBlock;
/// 结束刷新状态
- (void)endRefreshing;
/// 设置结束刷新状态回调
- (void)endRefreshingWithCompletionBlock:(dispatch_block_t)completionBlock;
/** 结束刷新的回调 */
@property (copy, nonatomic) dispatch_block_t endRefreshingCompletionBlock;
/** 是否正在刷新 */
@property (nonatomic, readonly, assign, getter=isRefreshing) BOOL refreshing;

#pragma mark ----- Other
/** 拉拽的百分比(交给子类重写) */
@property (nonatomic, assign) CGFloat pullingPercent;
/** 根据拖拽比例自动切换透明度 */
@property (nonatomic, assign, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
#pragma mark ----- 新扩展属性
/** 方向信息 */
@property (nonatomic, assign) TTTNRefreshScrollDirection tttn_direction;
/** 是否设置吸附效果 */
@property (nonatomic, assign) BOOL isAdsorption;

/// 获取箭头图标
- (UIImage *)tttn_getArrowImage:(BOOL)isHorizontal;

@end

NS_ASSUME_NONNULL_END

/**
 NS_REQUIRES_SUPER 作用是用于提醒子类复写方法时要调用super方法
 如果子类真的不想去调用super用NS_REQUIRES_SUPER修饰的方法，又不想出现警告，那么可以用下面的方式处理
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
 方法实现
 #pragma clang diagnostic pop
 */
NS_ASSUME_NONNULL_BEGIN

@interface UILabel (TTTNRefresh)
/// 竖向文本
@property (nonatomic) NSString *tttn_verticalText;
/// 创建标签
+ (instancetype)tttn_RefreshLabel;
/// 获取文本宽度
- (CGFloat)tttn_textWith;
/// 获取文本高度
- (CGFloat)tttn_textHeight;
@end

NS_ASSUME_NONNULL_END
