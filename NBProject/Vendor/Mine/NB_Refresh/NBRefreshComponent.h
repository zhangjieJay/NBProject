//
//  NBRefreshComponent.h
//  NBProject
//
//  Created by 张杰 on 2018/1/23.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "BaseView.h"

#import "NBRefreshConst.h"
#import "UIView+NBExtension.h"
#import "UIScrollView+NBExtension.h"

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, NBRefreshState) {
    /** 普通闲置状态 */
    NBRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    NBRefreshStatePulling,
    /** 正在刷新中的状态 */
    NBRefreshStateRefreshing,
    /** 即将刷新的状态 */
    NBRefreshStateWillRefresh,
//    /** 所有数据加载完毕，没有更多的数据了 */
//    NBRefreshStateNoMoreData
};

/** 进入刷新状态的回调 */
typedef void (^MJRefreshingBlock)(void);

@interface NBRefreshComponent : BaseView{
    /** 记录scrollView刚开始的inset */
    UIEdgeInsets _scrollViewOriginalInset;
    
    /** 父控件滚动视图 */
    __weak UIScrollView *_scrollView;
}

/** 刷新状态 一般交给子类内部实现 */
@property(nonatomic,assign)NBRefreshState state;


/** 根据拖拽比例自动切换透明度 */
@property (assign, nonatomic, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
/** 是否正在刷新 */
@property (assign, nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
/** 进入刷新状态的回调 */
@property(nonatomic,copy)MJRefreshingBlock refreshingBlock;


#pragma mark ------------------------------------ 交给子类们去实现
/** 初始化 */
- (void)prepare NS_REQUIRES_SUPER;
/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

/** 初始化控件 主要针对继承该类的子类 可自行进行控件封装*/
-(void)initBaseControls;

#pragma mark ------------------------------------ 刷新状态控制
/** 进入刷新状态 */
- (void)beginRefreshing;
/** 结束刷新状态 */
- (void)endRefreshing;

- (void)executeRefreshingCallback;
#pragma mark ------------------------------------ 交给子类去访问
/** 记录scrollView刚开始的inset */
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;
/** 父控件 */
@property (weak, nonatomic, readonly) UIScrollView *scrollView;

#pragma mark ------------------------------------ 交给子类
/** 拉拽的百分比(交给子类重写) */
@property (assign, nonatomic) CGFloat pullingPercent;

@end







@interface UILabel(NBRefresh)
+ (instancetype)nb_label;
- (CGFloat)nb_textWith;
@end

