//
//  TTTNRefreshStateHeader.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/4.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBackStateHeader.h"

@interface TTTNRefreshBackStateHeader()
/** 显示上一次刷新时间的label */
@property (nonatomic, readwrite) UILabel *lastUpdatedTimeLabel;
/** 显示刷新状态的label */
@property (nonatomic, readwrite) UILabel *stateLabel;
/** 所有状态对应的文字 */
@property (nonatomic, strong) NSMutableDictionary *stateTitles;
@end

@implementation TTTNRefreshBackStateHeader

#pragma mark ----- set get
- (UILabel *)lastUpdatedTimeLabel {
    if (_lastUpdatedTimeLabel) return _lastUpdatedTimeLabel;
    _lastUpdatedTimeLabel = [UILabel tttn_RefreshLabel];
    [self addSubview:_lastUpdatedTimeLabel];
    return _lastUpdatedTimeLabel;
}
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
    
    // 重新设置key（重新显示时间）
    self.lastUpdatedTimeKey = self.lastUpdatedTimeKey;
}
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey {
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    
    // 如果label隐藏了，就不用再处理
    if (self.lastUpdatedTimeLabel.hidden) return;
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.lastUpdatedTimeLabel.tttn_verticalText = self.lastUpdatedTimeText(lastUpdatedTime);
        }
        return;
    }
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [self _tttn_currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        BOOL isToday = NO;
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @" HH:mm";
            isToday = YES;
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@%@", TTTNRefreshHeaderLastTimeText, (isToday ? TTTNRefreshHeaderDateTodayText : @""), time];
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.lastUpdatedTimeLabel.tttn_verticalText = [NSString stringWithFormat:@"%@%@%@", TTTNRefreshHeaderLastTimeText, (isToday ? TTTNRefreshHeaderDateTodayText : @""), time];
        }
    } else {
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@", TTTNRefreshHeaderLastTimeText, TTTNRefreshHeaderNoneLastDateText];
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            self.lastUpdatedTimeLabel.tttn_verticalText = [NSString stringWithFormat:@"%@%@", TTTNRefreshHeaderLastTimeText, TTTNRefreshHeaderNoneLastDateText];
        }
    }
}
- (void)setTttn_direction:(TTTNRefreshScrollDirection)tttn_direction {
    [super setTttn_direction:tttn_direction];
    
    if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
        self.stateLabel.tttn_verticalText = self.stateTitles[@(self.state)];
        // 重新设置key（重新显示时间）
        self.lastUpdatedTimeKey = self.lastUpdatedTimeKey;
    }
}

#pragma mark ----- init Methods

#pragma mark ----- Override Methods
/// 准备方法
- (void)tttn_prepare {
    [super tttn_prepare];
    
    // 初始化文字
    [self tttn_setTitle:TTTNRefreshHeaderIdleText forState:TTTNRefreshStateIdle];
    [self tttn_setTitle:TTTNRefreshHeaderPullingText forState:TTTNRefreshStatePulling];
    [self tttn_setTitle:TTTNRefreshHeaderRefreshingText forState:TTTNRefreshStateRefreshing];
}
/// 设置控件位置
- (void)tttn_placeSubviewsFrame {
    // 拖动时修改不做处理
    if (self.scrollView.isDragging) return;
    
    [super tttn_placeSubviewsFrame];
    
    if (self.stateLabel.hidden) return;
    
    BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;
    
    if (self.lastUpdatedTimeLabel.hidden) {
        // 状态
        if (noConstrainsOnStatusLabel) self.stateLabel.frame = self.bounds;
    } else {
        CGFloat stateLabelSize = self.tttn_h * 0.5;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            stateLabelSize = self.tttn_w * 0.5;
        }
        // 状态
        if (noConstrainsOnStatusLabel) {
            if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
                self.stateLabel.tttn_x = 0;
                self.stateLabel.tttn_y = 0;
                self.stateLabel.tttn_w = self.tttn_w;
                self.stateLabel.tttn_h = stateLabelSize;
            }
            else {
                self.stateLabel.tttn_x = 0;
                self.stateLabel.tttn_y = 0;
                self.stateLabel.tttn_w = stateLabelSize;
                self.stateLabel.tttn_h = self.tttn_h;
            }
        }
        
        // 更新时间
        if (self.lastUpdatedTimeLabel.constraints.count == 0) {
            if (self.tttn_direction == TTTNRefreshScrollDirectionVertical) {
                self.lastUpdatedTimeLabel.tttn_x = 0;
                self.lastUpdatedTimeLabel.tttn_y = stateLabelSize;
                self.lastUpdatedTimeLabel.tttn_w = self.tttn_w;
                self.lastUpdatedTimeLabel.tttn_h = self.tttn_h - self.lastUpdatedTimeLabel.tttn_y;
            }
            else {
                self.lastUpdatedTimeLabel.tttn_x = stateLabelSize;
                self.lastUpdatedTimeLabel.tttn_y = 0;
                self.lastUpdatedTimeLabel.tttn_w = self.tttn_w - self.lastUpdatedTimeLabel.tttn_x;
                self.lastUpdatedTimeLabel.tttn_h = self.tttn_h;
            }
        }
    }
}
/// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    // 开启了吸附效果
    if (self.isAdsorption) {
        CGPoint newPoint = [change[@"new"] CGPointValue];
        CGPoint oldPoint = [change[@"old"] CGPointValue];
        
        CGFloat scrollOffsetValue = self.scrollView.tttn_offsetY;
        CGFloat top = self.scrollViewOriginalInset.top + self.tttn_h;
        
        CGFloat spacing = newPoint.y - oldPoint.y;
        if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
            scrollOffsetValue = self.scrollView.tttn_offsetX;
            top = self.scrollViewOriginalInset.left + self.tttn_w;
            spacing = newPoint.x - oldPoint.x;
        }
        spacing = (spacing < 0 ? spacing : 0);
        if (scrollOffsetValue+spacing <= -top) {
            if (self.tttn_direction == TTTNRefreshScrollDirectionHorizontal) {
                CGFloat offsetSize = scrollOffsetValue + self.scrollViewOriginalInset.left;
                offsetSize = fmin(-top, offsetSize);
                self.tttn_x = offsetSize;
            }
            else {
                CGFloat offsetSize = scrollOffsetValue + self.scrollViewOriginalInset.top;
                offsetSize = fmin(-top, offsetSize);
                self.tttn_y = offsetSize;
            }
        }
    }
}

#pragma mark ----- Private Methods
/// 获取日历
- (NSCalendar *)_tttn_currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

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

@end
