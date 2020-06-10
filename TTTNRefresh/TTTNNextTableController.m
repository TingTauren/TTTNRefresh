//
//  TTTNNextTableController.m
//  TTTNRefresh
//
//  Created by jiudun on 2020/6/9.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNNextTableController.h"

#import "TTTNRefresh.h"

@interface TTTNNextTableController ()<UITableViewDelegate, UITableViewDataSource>
/** 滚动视图 */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *listData;
@end

@implementation TTTNNextTableController

#pragma mark ----- set get方法
- (UITableView *)tableView {
    if (_tableView) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.frame = CGRectMake(0.0, 0.0, TTTN_ScreenWidth, TTTN_ScreenHeight-64.0);
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.tableFooterView = [UIView new];
    return _tableView;
}
- (NSMutableArray *)listData {
    if (_listData) return _listData;
    _listData = [NSMutableArray array];
    return _listData;
}

#pragma mark ----- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.78 green:0.24 blue:0.32 alpha:1.0];
    
    // 初始化数据
    [self _tttn_requestList];
    
    [self _tttn_handleViewConfig];
    [self _tttn_handleViewModelConfig];
}
#pragma mark ----- 处理回调
- (void)_tttn_handleViewConfig {
    [self.view addSubview:self.tableView];
    // 添加头部尾部刷新视图
    [self _tttn_addScrollViewHeaderFooter];
}
- (void)_tttn_handleViewModelConfig {
    
}

#pragma mark ----- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"TTTNNextTableControllerCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.textLabel.text = [NSString stringWithFormat:@"随机数据 - index = %ld", indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}
#pragma mark ----- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark ----- Click Methods

#pragma mark ----- Private Methods
/// 创建Header
- (id)_tttn_createHeader {
    __weak typeof(self) weakSelf = self;
    void(^ headerBlock)(void) = ^(void) {
        __strong typeof(weakSelf) self = weakSelf;
        [((TTTNRefreshFooter *)self.tableView.tttn_footerRefresh) resetNoMoreData];
        [self _tttn_requestList];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.tttn_headerRefresh endRefreshing];
        });
    };
    id header;
    NSInteger type = [_type integerValue];
    switch (type) {
        case 0: {
            header = [TTTNRefreshBackNormalHeader headerWithRefreshingBlock:headerBlock];
        }
            break;
        case 1: {
            header = [TTTNRefreshBackNormalHeader headerWithRefreshingBlock:headerBlock];
            ((TTTNRefreshBackStateHeader *)header).lastUpdatedTimeLabel.hidden = YES;
        }
            break;
        case 2:{
            header = [TTTNRefreshBackNormalHeader headerWithRefreshingBlock:headerBlock];
            ((TTTNRefreshBackStateHeader *)header).stateLabel.hidden = YES;
            ((TTTNRefreshBackStateHeader *)header).lastUpdatedTimeLabel.hidden = YES;
        }
            break;
        case 3:{
            header = [TTTNRefreshBackGifHeader headerWithRefreshingBlock:headerBlock];
            // 设置普通状态的动画图片
            NSMutableArray *idleImages = [NSMutableArray array];
            for (NSUInteger i = 1; i<=60; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
                [idleImages addObject:image];
            }
            [header tttn_setImages:idleImages forState:TTTNRefreshStateIdle];
            // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
            NSMutableArray *refreshingImages = [NSMutableArray array];
            for (NSUInteger i = 1; i<=3; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
                [refreshingImages addObject:image];
            }
            [header tttn_setImages:refreshingImages forState:TTTNRefreshStatePulling];
            // 设置正在刷新状态的动画图片
            [header tttn_setImages:refreshingImages forState:TTTNRefreshStateRefreshing];
        }
            break;
        case 4: {
            header = [TTTNRefreshBackNormalHeader headerWithRefreshingBlock:headerBlock];
            ((TTTNRefreshBackNormalHeader *)header).isAdsorption = YES;
        }
            break;
        case 5: {
            header = [TTTNRefreshAutoNormalHeader headerWithRefreshingBlock:headerBlock];
            ((TTTNRefreshAutoNormalHeader *)header).isShow = YES;
        }
            break;
        case 6: {
            header = [TTTNRefreshAutoNormalHeader headerWithRefreshingBlock:headerBlock];
            ((TTTNRefreshAutoNormalHeader *)header).isShow = NO;
        }
            break;
        default:
            break;
    }
    return header;
}
/// 创建Footer
- (id)_tttn_createFooter {
    __weak typeof(self) weakSelf = self;
    void(^ footerBlock)(void) = ^(void) {
        __strong typeof(weakSelf) self = weakSelf;
        [self _tttn_requestMoreList];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (self.listData.count > 20) {
                [((TTTNRefreshFooter *)self.tableView.tttn_footerRefresh) endRefreshingWithNoMoreData];
                return;
            }
            [self.tableView.tttn_footerRefresh endRefreshing];
        });
    };
    id footer;
    NSInteger type = [_type integerValue];
    switch (type) {
        case 0: {
            footer = [TTTNRefreshBackNormalFooter footerWithRefreshingBlock:footerBlock];
        }
            break;
        case 1: {
            footer = [TTTNRefreshBackNormalFooter footerWithRefreshingBlock:footerBlock];
        }
            break;
        case 2:{
            footer = [TTTNRefreshBackNormalFooter footerWithRefreshingBlock:footerBlock];
            ((TTTNRefreshBackNormalFooter *)footer).stateLabel.hidden = YES;
        }
            break;
        case 3:{
            footer = [TTTNRefreshBackGifFooter footerWithRefreshingBlock:footerBlock];
            // 设置普通状态的动画图片
            NSMutableArray *idleImages = [NSMutableArray array];
            for (NSUInteger i = 1; i<=60; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
                [idleImages addObject:image];
            }
            [footer tttn_setImages:idleImages forState:TTTNRefreshStateIdle];
            // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
            NSMutableArray *refreshingImages = [NSMutableArray array];
            for (NSUInteger i = 1; i<=3; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
                [refreshingImages addObject:image];
            }
            [footer tttn_setImages:refreshingImages forState:TTTNRefreshStatePulling];
            // 设置正在刷新状态的动画图片
            [footer tttn_setImages:refreshingImages forState:TTTNRefreshStateRefreshing];
        }
            break;
        case 4: {
            footer = [TTTNRefreshBackNormalFooter footerWithRefreshingBlock:footerBlock];
            ((TTTNRefreshBackNormalFooter *)footer).isAdsorption = YES;
        }
            break;
        case 5: {
            footer = [TTTNRefreshAutoNormalFooter footerWithRefreshingBlock:footerBlock];
            ((TTTNRefreshAutoNormalFooter *)footer).isShow = YES;
        }
            break;
        case 6: {
            footer = [TTTNRefreshAutoNormalFooter footerWithRefreshingBlock:footerBlock];
            ((TTTNRefreshAutoNormalFooter *)footer).isShow = NO;
        }
            break;
        default:
            break;
    }
    return footer;
}
/// 添加刷新控件
- (void)_tttn_addScrollViewHeaderFooter {
    _tableView.tttn_headerRefresh = [self _tttn_createHeader];
    _tableView.tttn_footerRefresh = [self _tttn_createFooter];
}

#pragma mark ----- Request Methods
/// 请求第一页数据
- (void)_tttn_requestList {
    [self.listData removeAllObjects];
    
    for (NSInteger i = 0; i < 6; i++) {
        [self.listData addObject:@(1)];
    }
}
/// 加载更多数据
- (void)_tttn_requestMoreList {
    NSInteger count = arc4random()%9+1;
    
    for (NSInteger i = 0; i < count; i++) {
        [self.listData addObject:@(1)];
    }
}

@end
