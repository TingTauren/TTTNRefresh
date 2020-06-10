//
//  TTTNRefreshAutoGifFooter.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/8.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshAutoGifFooter.h"

@interface TTTNRefreshAutoGifFooter()
/** 动态图片视图 */
@property (nonatomic, readwrite) UIImageView *gifView;
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;
@end

@implementation TTTNRefreshAutoGifFooter

#pragma mark ----- set get
- (UIImageView *)gifView {
    if (_gifView) return _gifView;
    _gifView = [[UIImageView alloc] init];
    [self addSubview:_gifView];
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
- (void)setState:(TTTNRefreshState)state {
    TTTNRefreshCheckState
    
    // 根据状态做事情
    if (state == TTTNRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        [self.gifView stopAnimating];
        
        self.gifView.hidden = NO;
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == TTTNRefreshStateNoMoreData || state == TTTNRefreshStateIdle) {
        [self.gifView stopAnimating];
        self.gifView.hidden = YES;
    }
}

#pragma mark ----- init Methods

#pragma mark ----- Override Methods
/// 准备方法
- (void)tttn_prepare {
    [super tttn_prepare];
    
    self.labelLeftInset = 20.0;
}
/// 摆放控件的位置
- (void)tttn_placeSubviewsFrame {
    [super tttn_placeSubviewsFrame];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    if (self.isRefreshingTitleHidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.gifView.contentMode = UIViewContentModeBottom;
            self.gifView.tttn_h = self.tttn_h * 0.5 - self.labelLeftInset - self.stateLabel.tttn_textHeight * 0.5;
        }
        else {
            self.gifView.contentMode = UIViewContentModeRight;
            self.gifView.tttn_w = self.tttn_w * 0.5 - self.labelLeftInset - self.stateLabel.tttn_textWith * 0.5;
        }
    }
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods
/// 设置state状态下的动画图片images 动画持续时间duration
/// @param images 动画图片
/// @param duration 持续时间
/// @param state 状态
- (void)tttn_setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(TTTNRefreshState)state {
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    BOOL check = (image.size.height > self.tttn_h);
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        check = (image.size.width > self.tttn_w);
    }
    if (check) {
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.tttn_w = image.size.width;
        }
        else {
            self.tttn_h = image.size.height;
        }
    }
}
/// 设置state状态下的动画图片images
/// @param images 动画图片
/// @param state 状态
- (void)tttn_setImages:(NSArray *)images forState:(TTTNRefreshState)state {
    [self tttn_setImages:images duration:1.0 forState:state];
}

@end
