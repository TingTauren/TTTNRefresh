//
//  TTTNRefreshAutoStateFooter.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/8.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshAutoStateFooter.h"

@interface TTTNRefreshAutoStateFooter()
/** 显示刷新状态的label */
@property (nonatomic, readwrite) UILabel *stateLabel;
/** 所有状态对应的文字 */
@property (nonatomic, strong) NSMutableDictionary *stateTitles;
@end

@implementation TTTNRefreshAutoStateFooter

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
    
    if (self.isRefreshingTitleHidden && state == TTTNRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.stateLabel.tttn_verticalText = self.stateTitles[@(state)];
        }
    }
}
- (void)setTttn_direction:(TTTNRefreshScrollDirection)tttn_direction {
    [super setTttn_direction:tttn_direction];
    self.stateLabel.text = self.stateTitles[@(self.state)];
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        self.stateLabel.tttn_verticalText = self.stateTitles[@(self.state)];
    }
}

#pragma mark ----- init Methods

#pragma mark ----- Override Methods
/// 准备方法
- (void)tttn_prepare {
    [super tttn_prepare];
    
    // 初始化间距
    self.labelLeftInset = 25.0;
    
    // 初始化文字
    [self tttn_setTitle:TTTNRefreshAutoFooterIdleText forState:TTTNRefreshStateIdle];
    [self tttn_setTitle:TTTNRefreshAutoFooterRefreshingText forState:TTTNRefreshStateRefreshing];
    [self tttn_setTitle:TTTNRefreshAutoFooterNoMoreDataText forState:TTTNRefreshStateNoMoreData];
    
    // 监听label
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}
/// 摆放子控件frame
- (void)tttn_placeSubviewsFrame {
    [super tttn_placeSubviewsFrame];
    
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods
/// 状态点击
- (void)stateLabelClick {
    if (self.state == TTTNRefreshStateIdle && self.state != TTTNRefreshStateNoMoreData) {
        [self beginRefreshing];
    }
}

#pragma mark ----- Public Methods
/** 设置state状态下的文字 */
- (void)tttn_setTitle:(NSString *)title forState:(TTTNRefreshState)state {
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        self.stateLabel.tttn_verticalText = self.stateTitles[@(self.state)];
    }
}

@end
