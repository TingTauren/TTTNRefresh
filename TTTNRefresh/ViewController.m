//
//  ViewController.m
//  TTTNRefresh
//
//  Created by jiudun on 2020/6/9.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "ViewController.h"

#import "TTTNRefresh.h"

#import "TTTNNextTableController.h"
#import "TTTNNextCollectionController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 列表视图 */
@property (nonatomic, strong) UITableView *tableView;
/** 水平 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 滑块 */
@property (nonatomic, strong) UISwitch *switchButton;
/** 头部数据 */
@property (nonatomic, strong) NSMutableArray *headerList;
/** 尾部数据 */
@property (nonatomic, strong) NSMutableArray *footerList;
@end

@implementation ViewController

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
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(TTTN_ScreenWidth-51.0-10.0-30.0, (44.0-20.0)/2.0, 25.0, 20.0);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:12.0];
    _titleLabel.text = @"水平";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    return _titleLabel;
}
- (UISwitch *)switchButton {
    if (_switchButton) return _switchButton;
    _switchButton = [[UISwitch alloc] init];
    _switchButton.frame = CGRectMake(TTTN_ScreenWidth-51.0-10.0, (44.0-31.0)/2.0, 51.0, 31.0);
    return _switchButton;
}
#pragma mark ----- 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.alpha = 1.0;
    self.switchButton.alpha = 1.0;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.titleLabel.alpha = 0.0;
    self.switchButton.alpha = 0.0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _tttn_initDate];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"TTTNRefresh演示";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.78 green:0.24 blue:0.32 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar addSubview:self.titleLabel];
    [self.navigationController.navigationBar addSubview:self.switchButton];
    
    [self _tttn_handleViewConfig];
    [self _tttn_handleViewModelConfig];
}
#pragma mark ----- 处理回调
- (void)_tttn_handleViewConfig {
    [self.view addSubview:self.tableView];
}
- (void)_tttn_handleViewModelConfig {
    
}

#pragma mark ----- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _headerList.count;
    }
    return _footerList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"ViewControllerCellIdentifier";
    ViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[ViewControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    id model;
    if (indexPath.section == 0) {
        model = [_headerList objectAtIndex:indexPath.row];
    }
    else {
        model = [_footerList objectAtIndex:indexPath.row];
    }
    [cell tttn_setModel:model];
    
    return cell;
}
#pragma mark ----- UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, TTTN_ScreenWidth, 15.0)];
    lable.backgroundColor = [UIColor darkGrayColor];
    lable.font = [UIFont systemFontOfSize:14.0];
    if (section == 0) {
        lable.text = @"  UITableView - 下拉刷新 - 上拉加载";
    }
    else {
        lable.text = @"  UICollection - 下拉刷新 - 上拉加载";
    }
    lable.textAlignment = NSTextAlignmentLeft;
    return lable;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewControllerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id type;
    if (indexPath.section == 0) {
        type = [_headerList objectAtIndex:indexPath.row];
        TTTNNextTableController *nextTableVC = [TTTNNextTableController new];
        nextTableVC.title = [cell tttn_getTitleLabel];
        nextTableVC.type = type;
        [self.navigationController pushViewController:nextTableVC animated:YES];
    }
    else {
        type = [_footerList objectAtIndex:indexPath.row];
        TTTNNextCollectionController *nextCollectionVC = [TTTNNextCollectionController new];
        nextCollectionVC.title = [cell tttn_getTitleLabel];
        nextCollectionVC.type = type;
        nextCollectionVC.isHorizontal = self.switchButton.isOn;
        [self.navigationController pushViewController:nextCollectionVC animated:YES];
    }
}

#pragma mark ----- Private Methods
/// 初始化数据
- (void)_tttn_initDate {
    [_headerList removeAllObjects];
    [_footerList removeAllObjects];
    
    _headerList = [NSMutableArray array];
    _footerList = [NSMutableArray array];
    
    [_headerList addObject:@(0)];
    [_headerList addObject:@(1)];
    [_headerList addObject:@(2)];
    [_headerList addObject:@(3)];
    [_headerList addObject:@(4)];
    [_headerList addObject:@(5)];
    [_headerList addObject:@(6)];
    
    [_footerList addObject:@(7)];
    [_footerList addObject:@(8)];
    [_footerList addObject:@(9)];
    [_footerList addObject:@(10)];
    [_footerList addObject:@(11)];
    [_footerList addObject:@(12)];
    [_footerList addObject:@(13)];
}

@end

#pragma mark ----- 分割线
@interface ViewControllerCell()
/** 文本 */
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation ViewControllerCell
#pragma mark ----- set get
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = self.bounds;
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.textColor = [UIColor darkTextColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    return _titleLabel;
}

#pragma mark ----- init Methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _tttn_initUI];
        [self _tttn_addUserEvents];
    }
    return self;
}
- (void)_tttn_initUI {
    [self.contentView addSubview:self.titleLabel];
}
- (void)_tttn_addUserEvents {
    
}

#pragma mark ----- Private Methods

#pragma mark ----- Click Methods

#pragma mark ----- Public Methods
- (NSString *)tttn_getTitleLabel {
    return self.titleLabel.text;
}
- (void)tttn_setModel:(id)model {
    NSInteger number = [model integerValue];
    switch (number) {
        case 0:
            _titleLabel.text = @"  默认BackNormal";
            break;
        case 1:
            _titleLabel.text = @"  隐藏时间BackNormal";
            break;
        case 2:
            _titleLabel.text = @"  隐藏状态和时间BackNormal";
            break;
        case 3:
            _titleLabel.text = @"  动画图片BackGif";
            break;
        case 4:
            _titleLabel.text = @"  默认BackNormal 固定效果";
            break;
        case 5:
            _titleLabel.text = @"  自动刷新AutoNormal 显示头脚";
            break;
        case 6:
            _titleLabel.text = @"  自动刷新AutoNormal 不显示显示头脚";
            break;
        case 7:
            _titleLabel.text = @"  默认BackNormal";
            break;
        case 8:
            _titleLabel.text = @"  隐藏时间BackNormal";
            break;
        case 9:
            _titleLabel.text = @"  隐藏状态和时间BackNormal";
            break;
        case 10:
            _titleLabel.text = @"  动画图片BackGif";
            break;
        case 11:
            _titleLabel.text = @"  默认BackNormal 固定效果";
            break;
        case 12:
            _titleLabel.text = @"  自动刷新AutoNormal 显示头脚";
            break;
        case 13:
            _titleLabel.text = @"  自动刷新AutoNormal 不显示显示头脚";
            break;
        default:
            break;
    }
}

@end
