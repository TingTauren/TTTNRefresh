//
//  TTTNRefreshConfig.m
//  TTTNRefresh
//
//  Created by jiudun on 2020/6/10.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshConfig.h"

@implementation TTTNRefreshConfig

+ (instancetype)defaultConfig {
    static TTTNRefreshConfig *tttn_RefreshConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tttn_RefreshConfig = [[self alloc] init];
    });
    return tttn_RefreshConfig;
}

@end
