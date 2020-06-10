//
//  TTTNRefreshGifHeader.m
//  TTTNTestCalendar
//
//  Created by TingTauren on 2020/6/7.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBackGifHeader.h"

@interface TTTNRefreshBackGifHeader()
/** Gif视图 */
@property (nonatomic, readwrite) UIImageView *gifView;
/** 所有状态对应的动画图片 */
@property (nonatomic, strong) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (nonatomic, strong) NSMutableDictionary *stateDurations;
@end

@implementation TTTNRefreshBackGifHeader

#pragma mark ----- set get
- (UIImageView *)gifView {
    if (_gifView) return _gifView;
    _gifView = [[UIImageView alloc] init];
    [self addSubview:self.gifView];
    return _gifView;
}
- (NSMutableDictionary *)stateImages {
    if (_stateImages) return _stateImages;
    _stateImages = [NSMutableDictionary dictionary];
    return _stateImages;
}
- (NSMutableDictionary *)stateDurations {
    if (_stateDurations) return _stateDurations;
    _stateDurations = [NSMutableDictionary dictionary];
    return _stateDurations;
}
/// 变化比例
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    // 获取普通闲置状态图片组
    NSArray *images = self.stateImages[@(TTTNRefreshStateIdle)];
    if (self.state != TTTNRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.gifView stopAnimating];
    // 设置当前需要显示的某一帧图片
    NSUInteger index = images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}
- (void)setState:(TTTNRefreshState)state {
    TTTNRefreshCheckState
    
    // 根据状态做事情
    if (state == TTTNRefreshStatePulling || state == TTTNRefreshStateRefreshing) { // 即将刷新和正在刷新中
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        }
        else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    }
    else if (state == TTTNRefreshStateIdle) { // 普通闲置装状态
        [self.gifView stopAnimating];
    }
}

#pragma mark ----- init Methods

#pragma mark ----- Override Methods
/// 准备方法
- (void)tttn_prepare {
    [super tttn_prepare];
    // 初始化间距
    self.labelLeftInset = 20;
}
/// 设置控件位置
- (void)tttn_placeSubviewsFrame {
    [super tttn_placeSubviewsFrame];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    }
    else {
        self.gifView.contentMode = UIViewContentModeRight;
        
        CGFloat stateSize = self.stateLabel.tttn_textWith;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            stateSize = self.stateLabel.tttn_textHeight;
        }
        CGFloat timeSize = 0.0;
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeSize = self.lastUpdatedTimeLabel.tttn_textWith;
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                timeSize = self.lastUpdatedTimeLabel.tttn_textHeight;
            }
        }
        CGFloat textSize = MAX(stateSize, timeSize);
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.gifView.tttn_h = self.tttn_h * 0.5 - textSize * 0.5 - self.labelLeftInset;
        }
        else {
            self.gifView.tttn_w = self.tttn_w * 0.5 - textSize * 0.5 - self.labelLeftInset;
        }
    }
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods
/// 设置state状态下的动画图片images 动画持续时间duration
/// @param images 动画图片
/// @param duration 持续时间
/// @param state 对应状态
- (void)tttn_setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(TTTNRefreshState)state {
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        if (image.size.width > self.tttn_w) {
            self.tttn_w = image.size.width;
        }
    }
    else {
        if (image.size.height > self.tttn_h) {
            self.tttn_h = image.size.height;
        }
    }
}
/// 设置state状态下的动画图片images
/// @param images 动画图片
/// @param state 对应状态
- (void)tttn_setImages:(NSArray *)images forState:(TTTNRefreshState)state {
    [self tttn_setImages:images duration:images.count * 0.1 forState:state];
}

@end
