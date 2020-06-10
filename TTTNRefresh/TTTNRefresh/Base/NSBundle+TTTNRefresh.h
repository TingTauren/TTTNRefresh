//
//  NSBundle+TTTNRefresh.h
//  TTTNRefresh
//
//  Created by jiudun on 2020/6/10.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 获取文字
#define TTTNRefreshLocalized(key) [NSBundle tttn_localizedStringForKey:key]

@interface NSBundle (TTTNRefresh)

/// 获取资源对象
+ (instancetype)tttn_bundle;
/// 根据key获取数据·
+ (NSString *)tttn_localizedStringForKey:(NSString *)key;
/// 根据key和value获取数据
+ (NSString *)tttn_localizedStringForKey:(NSString *)key value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
