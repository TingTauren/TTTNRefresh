//
//  ViewController.h
//  TTTNRefresh
//
//  Created by jiudun on 2020/6/9.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerCell : UITableViewCell

- (NSString *)tttn_getTitleLabel;
/// 设置数据源
- (void)tttn_setModel:(id)model;

@end

#pragma mark ----- 分割线

@interface ViewController : UIViewController

@end

