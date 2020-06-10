//
//  TTTNNextCollectionController.h
//  TTTNRefresh
//
//  Created by jiudun on 2020/6/9.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTTNNextCollectionController : UIViewController

/** 类型 */
@property (nonatomic, strong) NSNumber *type;

/** 是否水平 */
@property (nonatomic, assign) BOOL isHorizontal;

@end

NS_ASSUME_NONNULL_END
