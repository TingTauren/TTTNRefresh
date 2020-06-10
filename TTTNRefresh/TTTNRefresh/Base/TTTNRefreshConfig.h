//
//  TTTNRefreshConfig.h
//  TTTNRefresh
//
//  Created by jiudun on 2020/6/10.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTTNRefreshConfig : NSObject

/** 默认使用的语言版本, 默认为 nil. 将随系统的语言自动改变 */
@property (nonatomic, copy, nullable) NSString *languageCode;

/** @return Singleton Config instance */
+ (instancetype)defaultConfig;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
