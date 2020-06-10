//
//  UIView+TTTNExtension.h
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/3.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TTTNExtension)

#pragma mark ----- 快捷属性操作
/** 视图x */
@property (nonatomic, assign) CGFloat tttn_x;
/** 视图y */
@property (nonatomic, assign) CGFloat tttn_y;
/** 视图宽度 */
@property (nonatomic, assign) CGFloat tttn_w;
/** 视图高度 */
@property (nonatomic, assign) CGFloat tttn_h;
/** 视图大小 */
@property (nonatomic, assign) CGSize tttn_size;
/** 视图位置 */
@property (nonatomic, assign) CGPoint tttn_origin;

@end

NS_ASSUME_NONNULL_END
