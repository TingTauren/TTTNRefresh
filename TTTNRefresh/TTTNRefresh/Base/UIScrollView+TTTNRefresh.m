//
//  UIScrollView+TTTNRefresh.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/2.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "UIScrollView+TTTNRefresh.h"

#import <objc/runtime.h>

#import "TTTNRefreshBaseView.h" // 刷新视图基类

// 消除警告开始 (消除在消除警告开始和结束之间的代码警告)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"

@implementation NSObject (TTTNRefresh)
/// 实例方法交换
/// @param method1 方法一
/// @param method2 交换方法
+ (void)tttn_exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}
/// 类方法交换
/// @param method1 方法一
/// @param method2 交换方法
+ (void)tttn_exchangeClassMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}
@end

#pragma mark ----- 分割线

@implementation UIScrollView (TTTNRefresh)

#pragma mark ----- set get
#pragma mark ----- HeaderView
- (void)setTttn_headerRefresh:(TTTNRefreshBaseView *)tttn_headerRefresh {
    if (tttn_headerRefresh != self.tttn_headerRefresh) {
        // 删除旧的，添加新的
        [self.tttn_headerRefresh removeFromSuperview];
        [self insertSubview:tttn_headerRefresh atIndex:0];
        // 储存新的值
        objc_setAssociatedObject(self, @"tttn_headerRefresh", tttn_headerRefresh, OBJC_ASSOCIATION_RETAIN);
    }
}
- (TTTNRefreshBaseView *)tttn_headerRefresh {
    return objc_getAssociatedObject(self, @"tttn_headerRefresh");
}
#pragma mark ----- FooterView
- (void)setTttn_footerRefresh:(TTTNRefreshBaseView *)tttn_footerRefresh {
    if (tttn_footerRefresh != self.tttn_footerRefresh) {
        // 删除旧的，添加新的
        [self.tttn_footerRefresh removeFromSuperview];
        [self insertSubview:tttn_footerRefresh atIndex:0];
        // 储存新的值
        objc_setAssociatedObject(self, @"tttn_footerRefresh", tttn_footerRefresh, OBJC_ASSOCIATION_RETAIN);
    }
}
- (TTTNRefreshBaseView *)tttn_footerRefresh {
    return objc_getAssociatedObject(self, @"tttn_footerRefresh");
}

#pragma mark ----- init Methods
// 记录安全区状态
static BOOL tttnRespondsToAdjustedContentInset_;
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tttnRespondsToAdjustedContentInset_ = [self instancesRespondToSelector:@selector(adjustedContentInset)];
    });
}

#pragma mark ----- other
/// 获取列表数量
- (NSInteger)tttn_totalDataCount {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

#pragma mark ----- 快捷属性操作
/// 边距
- (UIEdgeInsets)tttn_inset {
#ifdef __IPHONE_11_0
    if (tttnRespondsToAdjustedContentInset_) {
        return self.adjustedContentInset;
    }
#endif
    return self.contentInset;
}
/// 设置顶部边距
- (void)setTttn_insetT:(CGFloat)tttn_insetT {
    UIEdgeInsets inset = self.contentInset;
    inset.top = tttn_insetT;
#ifdef __IPHONE_11_0
    if (tttnRespondsToAdjustedContentInset_) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
#endif
    self.contentInset = inset;
}
/// 获取顶部边距
- (CGFloat)tttn_insetT {
    return self.tttn_inset.top;
}
/// 设置底部边距
- (void)setTttn_insetB:(CGFloat)tttn_insetB {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = tttn_insetB;
#ifdef __IPHONE_11_0
    if (tttnRespondsToAdjustedContentInset_) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
#endif
    self.contentInset = inset;
}
/// 获取底部边距
- (CGFloat)tttn_insetB {
    return self.tttn_inset.bottom;
}
/// 设置左边距
- (void)setTttn_insetL:(CGFloat)tttn_insetL {
    UIEdgeInsets inset = self.contentInset;
    inset.left = tttn_insetL;
#ifdef __IPHONE_11_0
    if (tttnRespondsToAdjustedContentInset_) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
#endif
    self.contentInset = inset;
}
/// 获取左边距
- (CGFloat)tttn_insetL {
    return self.tttn_inset.left;
}
/// 设置右边距
- (void)setTttn_insetR:(CGFloat)tttn_insetR {
    UIEdgeInsets inset = self.contentInset;
    inset.right = tttn_insetR;
#ifdef __IPHONE_11_0
    if (tttnRespondsToAdjustedContentInset_) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
#endif
    self.contentInset = inset;
}
/// 获取右边距
- (CGFloat)tttn_insetR {
    return self.tttn_inset.right;
}
/// 设置内容偏移X
- (void)setTttn_offsetX:(CGFloat)tttn_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = tttn_offsetX;
    self.contentOffset = offset;
}
/// 获取内容偏移X
- (CGFloat)tttn_offsetX {
    return self.contentOffset.x;
}
/// 设置内容偏移Y
- (void)setTttn_offsetY:(CGFloat)tttn_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = tttn_offsetY;
    self.contentOffset = offset;
}
/// 获取内容偏移Y
- (CGFloat)tttn_offsetY {
    return self.contentOffset.y;
}
/// 设置内容宽度
- (void)setTttn_contentW:(CGFloat)tttn_contentW {
    CGSize size = self.contentSize;
    size.width = tttn_contentW;
    self.contentSize = size;
}
/// 获取内容宽度
- (CGFloat)tttn_contentW {
    return self.contentSize.width;
}
/// 设置内容高度
- (void)setTttn_contentH:(CGFloat)tttn_contentH {
    CGSize size = self.contentSize;
    size.height = tttn_contentH;
    self.contentSize = size;
}
/// 获取内容高度
- (CGFloat)tttn_contentH {
    return self.contentSize.height;
}

@end

// 消除警告结束
#pragma clang diagnostic pop
