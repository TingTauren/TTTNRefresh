//
//  TTTNRefreshBackStateFooter.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/5.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBackStateFooter.h"

@interface TTTNRefreshBackStateFooter()
/** 显示刷新状态的label */
@property (nonatomic, readwrite) UILabel *stateLabel;
/** 所有状态对应的文字 */
@property (nonatomic, strong) NSMutableDictionary *stateTitles;
@end

@implementation TTTNRefreshBackStateFooter

#pragma mark ----- set get
- (UILabel *)stateLabel {
    if (_stateLabel) return _stateLabel;
    _stateLabel = [UILabel tttn_RefreshLabel];
    [self addSubview:_stateLabel];
    return _stateLabel;
}
- (NSMutableDictionary *)stateTitles {
    if (_stateTitles) return _stateTitles;
    _stateTitles = [NSMutableDictionary dictionary];
    return _stateTitles;
}
- (void)setState:(TTTNRefreshState)state {
    TTTNRefreshCheckState
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        self.stateLabel.tttn_verticalText = self.stateTitles[@(state)];
    }
}
- (void)setTttn_direction:(TTTNRefreshScrollDirection)tttn_direction {
    [super setTttn_direction:tttn_direction];
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        self.stateLabel.tttn_verticalText = self.stateTitles[@(self.state)];
    }
}

#pragma mark ----- init Methods

#pragma mark ----- Override Methods
/// 准备方法
- (void)tttn_prepare {
    [super tttn_prepare];
    
    // 初始化文字
    [self tttn_setTitle:TTTNRefreshBackFooterIdleText forState:TTTNRefreshStateIdle];
    [self tttn_setTitle:TTTNRefreshBackFooterPullingText forState:TTTNRefreshStatePulling];
    [self tttn_setTitle:TTTNRefreshBackFooterRefreshingText forState:TTTNRefreshStateRefreshing];
    [self tttn_setTitle:TTTNRefreshBackFooterNoMoreDataText forState:TTTNRefreshStateNoMoreData];
}
/// 设置控件位置
- (void)tttn_placeSubviewsFrame {
    // 拖动时修改不做处理
    if (self.scrollView.isDragging) return;
    
    [super tttn_placeSubviewsFrame];
    
    // 如果设置了约束
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}
/// 当scrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    if (self.scrollView.isDragging) return;
    [super scrollViewContentSizeDidChange:change];
}
/// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    // 开启了吸附效果
    if (self.isAdsorption) {
        // 内容的高度
        CGFloat scrollOffsetValue = self.scrollView.tttn_offsetY;
        CGFloat refreshSize = self.scrollViewOriginalInset.bottom + self.tttn_h;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            scrollOffsetValue = self.scrollView.tttn_offsetX;
            refreshSize = self.scrollViewOriginalInset.right + self.tttn_w;
        }
        
        if (scrollOffsetValue >= refreshSize) {
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                CGFloat offsetSize = self.scrollView.tttn_w + scrollOffsetValue - refreshSize;
                // 刷新完成后要设置到内容下面,不然普通状态会遮挡内容
                if ((self.state == TTTNRefreshStateIdle || self.state == TTTNRefreshStateNoMoreData) && self.scrollView.tttn_contentW > offsetSize) {
                    offsetSize = self.scrollView.tttn_contentW + self.ignoredScrollViewContentInsetMargin;
                }
                self.tttn_x = offsetSize;
            }
            else {
                CGFloat offsetSize = self.scrollView.tttn_h + scrollOffsetValue - refreshSize;
                // 刷新完成后要设置到内容下面,不然普通状态会遮挡内容
                if ((self.state == TTTNRefreshStateIdle || self.state == TTTNRefreshStateNoMoreData) && self.scrollView.tttn_contentH > offsetSize) {
                    offsetSize = self.scrollView.tttn_contentH + self.ignoredScrollViewContentInsetMargin;
                }
                self.tttn_y = offsetSize;
            }
        }
    }
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods
/// 设置state状态下的文字
- (void)tttn_setTitle:(NSString *)title forState:(TTTNRefreshState)state {
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        self.stateLabel.tttn_verticalText = self.stateTitles[@(self.state)];
    }
}
/// 获取状态下的文字
- (NSString *)tttn_titleForState:(TTTNRefreshState)state {
    return self.stateTitles[@(state)];
}

@end
