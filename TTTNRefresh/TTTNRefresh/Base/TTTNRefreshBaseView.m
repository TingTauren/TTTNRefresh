//
//  TTTNRefreshBaseView.m
//  TTTNTestCalendar
//
//  Created by jiudun on 2020/6/2.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBaseView.h"
#import <objc/message.h>

NSString *const TTTNRefreshKeyPathContentOffset =
@"contentOffset";
NSString *const TTTNRefreshKeyPathContentInset =
@"contentInset";
NSString *const TTTNRefreshKeyPathContentSize =
@"contentSize";
NSString *const TTTNRefreshKeyPathPanState =
@"state";

const CGFloat TTTNRefreshFastAnimationDuration =
0.25;
const CGFloat TTTNRefreshSlowAnimationDuration =
0.4;

@interface TTTNRefreshBaseView()
/** 滚动视图手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *scrollPanGesture;
@end

@implementation TTTNRefreshBaseView

#pragma mark ----- set get
/// 是否正在刷新
- (BOOL)isRefershing {
    return (self.state == TTTNRefreshStateRefreshing || self.state == TTTNRefreshStateWillRefresh);
}
- (void)setPullingPercent:(CGFloat)pullingPercent {
    _pullingPercent = pullingPercent;
    if (self.isRefreshing) return;
    if (self.isAutomaticallyChangeAlpha) {
        self.alpha = pullingPercent;
    }
}
- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha {
    _automaticallyChangeAlpha = automaticallyChangeAlpha;
    if (self.isRefreshing) return;
    if (automaticallyChangeAlpha) {
        self.alpha = self.pullingPercent;
    } else {
        self.alpha = 1.0;
    }
}
- (void)setState:(TTTNRefreshState)state {
    _state = state;
    /**
     加入主队列的目的是等setState:方法调用完毕
     设置完文字后再去布局子控件
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}
- (void)setTttn_direction:(TTTNRefreshScrollDirection)tttn_direction {
    _tttn_direction = tttn_direction;
    /**
     加入主队列的目的是等setState:方法调用完毕
     设置完文字后再去布局子控件
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

#pragma mark ----- init Methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 准备方法
        [self tttn_prepare];
        // 普通闲置状态
        self.state = TTTNRefreshStateIdle;
        // 方向信息
        self.tttn_direction = TTTNRefreshScrollDirectionVertical;
    }
    return self;
}
/// 设置回调对象和方法
- (void)setRefreshingTarget:(id)target regreshingAction:(SEL)action {
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

#pragma mark ----- Override Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self tttn_placeSubviewsFrame];
}
/// 当视图即将加入父视图时 / 当视图即将从父视图移除时调用
/// @param newSuperview 为空就表示移除
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    // 旧的父控件移除监听
    [self _tttn_removeObservers];
    
    // 新的父控件
    if (newSuperview) {
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.tttn_inset;
        
//        if (_tttn_direction == TTTNRefreshScrollDirectionNormal) {
//            // 设置滚动方向
//            _tttn_direction = (self.scrollView.tttn_contentW > self.scrollView.tttn_contentH ? TTTNRefreshScrollDirectionHorizontal : TTTNRefreshScrollDirectionVertical);
//        }
        if (_tttn_direction == TTTNRefreshScrollDirectionVertical) {
            // 设置宽度
            self.tttn_w = newSuperview.tttn_w;
            // 设置位置
            self.tttn_x = -_scrollView.tttn_insetL;
            // 设置永远支持垂直弹簧效果
            _scrollView.alwaysBounceVertical = YES;
            // 设置永远支持水平弹簧效果
            _scrollView.alwaysBounceHorizontal = NO;
        }
        else {
            // 设置高度
            self.tttn_h = newSuperview.tttn_h;
            // 设置位置
            self.tttn_y = -_scrollView.tttn_insetT;
            // 设置永远支持垂直弹簧效果
            _scrollView.alwaysBounceVertical = NO;
            // 设置永远支持水平弹簧效果
            _scrollView.alwaysBounceHorizontal = YES;
        }
        
        // 添加监听
        [self _tttn_addObservers];
    }
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.state == TTTNRefreshStateWillRefresh) {
        // 预防view还没显示出来就调用了beginRefreshing
        self.state = TTTNRefreshStateRefreshing;
    }
}

#pragma mark ----- Private Methods
/// 添加控件监听
- (void)_tttn_addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:TTTNRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:TTTNRefreshKeyPathContentSize options:options context:nil];
    self.scrollPanGesture = self.scrollView.panGestureRecognizer;
    [self.scrollPanGesture addObserver:self forKeyPath:TTTNRefreshKeyPathPanState options:options context:nil];
}
/// 移除控件监听
- (void)_tttn_removeObservers {
    [self.superview removeObserver:self forKeyPath:TTTNRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:TTTNRefreshKeyPathContentSize];
    [self.scrollPanGesture removeObserver:self forKeyPath:TTTNRefreshKeyPathPanState];
    self.scrollPanGesture = nil;
}

#pragma mark ----- KVO监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:TTTNRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    // 看不见
    if (self.hidden) return;
    if ([keyPath isEqualToString:TTTNRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:TTTNRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods
/// 准备方法
- (void)tttn_prepare {
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
}
/// 摆放子控件frame
- (void)tttn_placeSubviewsFrame {}
/// 当scrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {}
/// 当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {}
/// 当scrollView的拖拽状态发生改变的时候调用
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {}

/// 触发正在刷新的回调(交给子类去调用)
- (void)tttn_executeRefreshingCallback {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            // 消息发送
            ((void (*)(void *, SEL, UIView *))objc_msgSend)((__bridge void *)(self.refreshingTarget), self.refreshingAction, self);
        }
        if (self.beginRefreshingCompletionBlock) {
            self.beginRefreshingCompletionBlock();
        }
    });
}

/// 进入刷新状态
- (void)beginRefreshing {
    [UIView animateWithDuration:TTTNRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    // 设置拖拽百分比
    self.pullingPercent = 1.0;
    // 只要正在刷新，就完全显示
    if (self.window) {
        self.state = TTTNRefreshStateRefreshing;
    }
    else {
        // 预防正在刷新中时，调用本方法使得header inset回置失败
        if (self.state != TTTNRefreshStateRefreshing) {
            self.state = TTTNRefreshStateWillRefresh;
            /**
             刷新
             预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下
             */
            [self setNeedsDisplay];
        }
    }
}
/// 设置进入刷新状态回调
- (void)beginRefreshingWithCompletionBlock:(dispatch_block_t)completionBlock {
    self.beginRefreshingCompletionBlock = completionBlock;
    [self beginRefreshing];
}
/// 结束刷新状态
- (void)endRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = TTTNRefreshStateIdle;
    });
}
/// 设置结束刷新状态回调
- (void)endRefreshingWithCompletionBlock:(dispatch_block_t)completionBlock {
    self.endRefreshingCompletionBlock = completionBlock;
    [self endRefreshing];
}

/// 获取箭头图标
- (UIImage *)tttn_getArrowImage:(BOOL)isHorizontal {
    NSString *tttnRefershBoudle = @"TTTNRefresh.bundle";
    NSString *tttnRefershPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:tttnRefershBoudle];
    NSBundle *tttnRefreshBundle = [NSBundle bundleWithPath:tttnRefershPath];
    UIImage *image = [UIImage imageNamed:(isHorizontal ? @"arrowHorizontal" : @"arrow") inBundle:tttnRefreshBundle compatibleWithTraitCollection:nil];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return image;
}

@end

#pragma mark ----- 分割线

@implementation UILabel (TTTNExtension)
/// 获取竖向文本
- (NSString *)tttn_verticalText {
    return objc_getAssociatedObject(self, @"tttn_verticalText");
}
/// 设置竖向文本
- (void)setTttn_verticalText:(NSString *)tttn_verticalText {
    if (!tttn_verticalText || [tttn_verticalText isEqualToString:@""]) return;
    objc_setAssociatedObject(self, @"tttn_verticalText", tttn_verticalText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableString *str = [[NSMutableString alloc] initWithString:tttn_verticalText];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2-1];
    }
    self.text = str;
    self.numberOfLines = 0;
}
/// 创建标签
+ (instancetype)tttn_RefreshLabel {
    UILabel *label = [[self alloc] init];
    label.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    label.font = TTTNRefreshLabelFont;
    label.textColor = TTTNRefreshLabelTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return label;
}
/// 获取文本宽度
- (CGFloat)tttn_textWith {
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.text.length > 0) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 0.0; // 设置行间距
        // 设置字间距 NSKernAttributeName:@1.5f
        NSDictionary *dic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(1.5f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.text attributes:dic];
        CGSize rtSize = [attr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        stringWidth = rtSize.width;
//#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//        stringWidth = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width;
//#else
//        stringWidth = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping].width;
//#endif
    }
    return stringWidth;
}
/// 获取文本宽度
- (CGFloat)tttn_textHeight {
    CGFloat stringHeight = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.text.length > 0) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 0.0; // 设置行间距
        // 设置字间距 NSKernAttributeName:@1.5f
        NSDictionary *dic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(1.5f)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.text attributes:dic];
        CGSize rtSize = [attr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        stringHeight = rtSize.height;
    }
    return stringHeight;
}

@end
