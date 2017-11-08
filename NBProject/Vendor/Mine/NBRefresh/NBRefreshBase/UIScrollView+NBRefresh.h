//
//  UIScrollView+NBRefresh.h
//  NBProject
//
//  Created by scuser on 2017/11/6.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBRefreshConst.h"

#import "NBRefreshHeader.h"
#import "NBRefreshFooter.h"

//@class NBRefreshHeader, NBRefreshFooter;

@interface UIScrollView (NBRefresh)
/** 下拉刷新控件 */
@property (strong, nonatomic) NBRefreshHeader *nb_header;
/** 上拉刷新控件 */
@property (strong, nonatomic) NBRefreshFooter *nb_footer;

#pragma mark - other
- (NSInteger)nb_totalDataCount;
@property (copy, nonatomic) void (^nb_reloadDataBlock)(NSInteger totalDataCount);
@end
