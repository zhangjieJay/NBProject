//
//  NBRefreshHeader.h
//  NBProject
//
//  Created by 张杰 on 2018/1/23.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBRefreshComponent.h"
/***此类只用于UIScrollView偏移量及状态的改变***/

@interface NBRefreshHeader : NBRefreshComponent
/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshingBlock)refreshingBlock;

/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;
@end
