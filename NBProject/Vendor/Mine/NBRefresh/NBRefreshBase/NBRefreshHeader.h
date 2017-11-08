//
//  NBRefreshHeader.h
//  NBProject
//
//  Created by scuser on 2017/11/6.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRefreshComponent.h"

@interface NBRefreshHeader : NBRefreshComponent
/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(NBRefreshComponentRefreshingBlock)refreshingBlock;
/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 这个key用来存储上一次下拉刷新成功的时间 */
@property (copy, nonatomic) NSString *lastUpdatedTimeKey;
/** 上一次下拉刷新成功的时间 */
@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;

/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;
@end
