//
//  UIView+TTTNExtension.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/3.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "UIView+TTTNExtension.h"

#import "TTTNRefreshAutoFooter.h"

@implementation UIView (TTTNExtension)

#pragma mark ----- 快捷属性操作
/// 设置视图x
- (void)setTttn_x:(CGFloat)tttn_x {
    CGRect frame = self.frame;
    frame.origin.x = tttn_x;
    self.frame = frame;
}
/// 获取视图x
- (CGFloat)tttn_x {
    return self.frame.origin.x;
}
/// 设置视图y
- (void)setTttn_y:(CGFloat)tttn_y {
    CGRect frame = self.frame;
    frame.origin.y = tttn_y;
    self.frame = frame;
}
/// 获取视图y
- (CGFloat)tttn_y {
    return self.frame.origin.y;
}
/// 设置视图宽度
- (void)setTttn_w:(CGFloat)tttn_w {
    CGRect frame = self.frame;
    frame.size.width = tttn_w;
    self.frame = frame;
}
/// 获取视图宽度
- (CGFloat)tttn_w {
    return self.frame.size.width;
}
/// 设置视图高度
- (void)setTttn_h:(CGFloat)tttn_h {
    CGRect frame = self.frame;
    frame.size.height = tttn_h;
    self.frame = frame;
}
/// 获取视图高度
- (CGFloat)tttn_h {
    return self.frame.size.height;
}
/// 设置视图大小
- (void)setTttn_size:(CGSize)tttn_size {
    CGRect frame = self.frame;
    frame.size = tttn_size;
    self.frame = frame;
}
/// 获取视图大小
- (CGSize)tttn_size {
    return self.frame.size;
}
/// 设置视图位置
- (void)setTttn_origin:(CGPoint)tttn_origin {
    CGRect frame = self.frame;
    frame.origin = tttn_origin;
    self.frame = frame;
}
/// 获取视图位置
- (CGPoint)tttn_origin {
    return self.frame.origin;
}

@end
