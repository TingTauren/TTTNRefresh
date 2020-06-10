//
//  TTTNNextCollectionController.m
//  TTTNRefresh
//
//  Created by jiudun on 2020/6/9.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNNextCollectionController.h"

#import "TTTNRefresh.h"

#define k_TTTNNextCollectionControllerCell @"TTTNNextCollectionControllerCellIdentifier"

@interface TTTNNextCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 滚动视图 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *listData;
@end

@implementation TTTNNextCollectionController

#pragma mark ----- set get方法
- (UICollectionView *)collectionView {
    if (_collectionView) return _collectionView;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    NSInteger count = (self.isHorizontal ? 5 : 3);
    CGFloat leftSpacing = 0.0;
    CGFloat itemSpcaing = 0.0;
    CGFloat itemWith = (TTTN_ScreenWidth-leftSpacing*2.0-itemSpcaing*(count-1))/count;
    if (self.isHorizontal) {
        itemWith = (TTTN_ScreenHeight-64.0-leftSpacing*2.0-itemSpcaing*(count-1))/count;
    }
    layout.itemSize = CGSizeMake(itemWith, itemWith);
    layout.minimumLineSpacing = itemSpcaing;
    layout.minimumInteritemSpacing = itemSpcaing;
    layout.sectionInset = UIEdgeInsetsMake(0.0, leftSpacing, 0.0, leftSpacing);
    layout.scrollDirection = self.isHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.frame = CGRectMake(0.0, 0.0, TTTN_ScreenWidth, TTTN_ScreenHeight-64.0);
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:k_TTTNNextCollectionControllerCell];
    return _collectionView;
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
    [self.view addSubview:self.collectionView];
    
    /// 添加刷新控件
    [self _tttn_addScrollViewHeaderFooter];
}
- (void)_tttn_handleViewModelConfig {
    
}

#pragma mark ----- Collection DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:k_TTTNNextCollectionControllerCell forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    
    return cell;
}
#pragma mark ----- Collection Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ----- Private Methods
/// 创建Header
- (id)_tttn_createHeader {
    __weak typeof(self) weakSelf = self;
    void(^ headerBlock)(void) = ^(void) {
        __strong typeof(weakSelf) self = weakSelf;
        [((TTTNRefreshFooter *)self.collectionView.tttn_footerRefresh) resetNoMoreData];
        [self _tttn_requestList];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.collectionView.tttn_headerRefresh endRefreshing];
        });
    };
    id header;
    NSInteger type = [_type integerValue];
    switch (type) {
        case 7: {
            header = [TTTNRefreshBackNormalHeader headerWithRefreshingBlock:headerBlock];
        }
            break;
        case 8: {
            header = [TTTNRefreshBackNormalHeader headerWithRefreshingBlock:headerBlock];
            ((TTTNRefreshBackStateHeader *)header).lastUpdatedTimeLabel.hidden = YES;
        }
            break;
        case 9:{
            header = [TTTNRefreshBackNormalHeader headerWithRefreshingBlock:headerBlock];
            ((TTTNRefreshBackStateHeader *)header).stateLabel.hidden = YES;
            ((TTTNRefreshBackStateHeader *)header).lastUpdatedTimeLabel.hidden = YES;
        }
            break;
        case 10:{
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
        case 11: {
            header = [TTTNRefreshBackNormalHeader headerWithRefreshingBlock:headerBlock];
            ((TTTNRefreshBackNormalHeader *)header).isAdsorption = YES;
        }
            break;
        case 12: {
            header = [TTTNRefreshAutoNormalHeader headerWithRefreshingBlock:headerBlock];
            ((TTTNRefreshAutoNormalHeader *)header).isShow = YES;
        }
            break;
        case 13: {
            header = [TTTNRefreshAutoNormalHeader headerWithRefreshingBlock:headerBlock];
            ((TTTNRefreshAutoNormalHeader *)header).isShow = NO;
        }
            break;
        default:
            break;
    }
    if (self.isHorizontal) {
        ((TTTNRefreshHeader *)header).tttn_direction = TTTNRefreshScrollDirectionHorizontal;
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
            [self.collectionView reloadData];
            if (self.listData.count > 40) {
                [((TTTNRefreshFooter *)self.collectionView.tttn_footerRefresh) endRefreshingWithNoMoreData];
                return;
            }
            [self.collectionView.tttn_footerRefresh endRefreshing];
        });
    };
    id footer;
    NSInteger type = [_type integerValue];
    switch (type) {
        case 7: {
            footer = [TTTNRefreshBackNormalFooter footerWithRefreshingBlock:footerBlock];
        }
            break;
        case 8: {
            footer = [TTTNRefreshBackNormalFooter footerWithRefreshingBlock:footerBlock];
        }
            break;
        case 9:{
            footer = [TTTNRefreshBackNormalFooter footerWithRefreshingBlock:footerBlock];
            ((TTTNRefreshBackNormalFooter *)footer).stateLabel.hidden = YES;
        }
            break;
        case 10:{
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
        case 11: {
            footer = [TTTNRefreshBackNormalFooter footerWithRefreshingBlock:footerBlock];
            ((TTTNRefreshBackNormalFooter *)footer).isAdsorption = YES;
        }
            break;
        case 12: {
            footer = [TTTNRefreshAutoNormalFooter footerWithRefreshingBlock:footerBlock];
            ((TTTNRefreshAutoNormalFooter *)footer).isShow = YES;
        }
            break;
        case 13: {
            footer = [TTTNRefreshAutoNormalFooter footerWithRefreshingBlock:footerBlock];
            ((TTTNRefreshAutoNormalFooter *)footer).isShow = NO;
        }
            break;
        default:
            break;
    }
    if (self.isHorizontal) {
        ((TTTNRefreshFooter *)footer).tttn_direction = TTTNRefreshScrollDirectionHorizontal;
    }
    return footer;
}
/// 添加刷新控件
- (void)_tttn_addScrollViewHeaderFooter {
    _collectionView.tttn_headerRefresh = [self _tttn_createHeader];
    _collectionView.tttn_footerRefresh = [self _tttn_createFooter];
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
    NSInteger count = arc4random()%5+5;
    
    for (NSInteger i = 0; i < count; i++) {
        [self.listData addObject:@(1)];
    }
}

@end
