//
//  TTTNRefreshNormalHeader.h
//  TTTNTestCalendar
//
//  Created by TingTauren on 2020/6/6.
//  Copyright © 2020 TTTN. All rights reserved.
//

#import "TTTNRefreshBackStateHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTNRefreshBackNormalHeader : TTTNRefreshBackStateHeader
/** 箭头图标 */
@property (nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end

NS_ASSUME_NONNULL_END
