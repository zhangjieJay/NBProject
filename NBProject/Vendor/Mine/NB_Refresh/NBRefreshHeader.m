//
//  NBRefreshHeader.m
//  NBProject
//
//  Created by 张杰 on 2018/1/23.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBRefreshHeader.h"

@interface NBRefreshHeader()

@property (assign, nonatomic) CGFloat insetTDelta;

@end

@implementation NBRefreshHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(instancetype)headerWithRefreshingBlock:(MJRefreshingBlock)refreshingBlock{
    NBRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
    
}
-(void)initBaseControls{
    [super initBaseControls];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.nb_y = - self.nb_h - self.ignoredScrollViewContentInsetTop;
}
#pragma mark ------------------------------------ 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    self.nb_h = NBRefreshHeaderHeight;
    
}


-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    // 在刷新的refreshing状态
    if (self.state == NBRefreshStateRefreshing) {
        // 暂时保留
        if (self.window == nil) return;
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.nb_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.nb_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.nb_h + _scrollViewOriginalInset.top ? self.nb_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.nb_insetT = insetT;
        
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变,所以先进行储存 方便再次使用时出现错乱
    _scrollViewOriginalInset = self.scrollView.nb_inset;
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.nb_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.nb_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.nb_h;
    
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == NBRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态(拖动和刷新之间)
            self.state = NBRefreshStatePulling;
        } else if (self.state == NBRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            //拖动但是未拖动到临界点  转为普通状态
            self.state = NBRefreshStateIdle;
        }
    } else if (self.state == NBRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
        
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }

}


-(void)setState:(NBRefreshState)state{
    NBCheckState

    // 根据状态做事情
    if (state == NBRefreshStateIdle) {
        if (oldState != NBRefreshStateRefreshing) return;
        
        // 恢复inset和offset
        [UIView animateWithDuration:NBRefreshSlowAnimationDuration animations:^{
            self.scrollView.nb_insetT += self.insetTDelta;
            
            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
            
        }];
    } else if (state == NBRefreshStateRefreshing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:NBRefreshFastAnimationDuration animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + self.nb_h;
                // 增加滚动区域top
                self.scrollView.nb_insetT = top;
                // 设置滚动位置
                CGPoint offset = self.scrollView.contentOffset;
                offset.y = -top;
                [self.scrollView setContentOffset:offset animated:NO];
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        });
    }
    
}


@end
