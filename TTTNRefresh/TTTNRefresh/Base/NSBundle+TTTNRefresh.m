//
//  NSBundle+TTTNRefresh.m
//  TTTNRefresh
//
//  Created by jiudun on 2020/6/10.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "NSBundle+TTTNRefresh.h"

#import "TTTNRefreshBaseView.h"
#import "TTTNRefreshConfig.h" // 配置文件

@implementation NSBundle (TTTNRefresh)

/// 获取资源对象
+ (instancetype)tttn_bundle {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[TTTNRefreshBaseView class]] pathForResource:@"TTTNRefresh" ofType:@"bundle"]];
    }
    return bundle;
}
/// 根据key获取数据·
+ (NSString *)tttn_localizedStringForKey:(NSString *)key {
    return [self tttn_localizedStringForKey:key value:nil];
}
/// 根据key和value获取数据
+ (NSString *)tttn_localizedStringForKey:(NSString *)key value:(NSString *)value {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [TTTNRefreshConfig defaultConfig].languageCode;
        // 如果配置中没有配置语言
        if (!language) {
            // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
            language = [NSLocale preferredLanguages].firstObject;
        }
        
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans";
            } else {
                language = @"zh-Hant";
            }
        } else if ([language hasPrefix:@"ko"]) {
            language = @"ko";
        } else if ([language hasPrefix:@"ru"]) {
            language = @"ru";
        } else if ([language hasPrefix:@"uk"]) {
            language = @"uk";
        } else {
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[[NSBundle tttn_bundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:(key) value:(value) table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end
