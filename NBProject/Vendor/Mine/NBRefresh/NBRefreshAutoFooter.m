//
//  NBRefreshAutoFooter.m
//  NBProject
//
//  Created by scuser on 2017/11/7.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRefreshAutoFooter.h"

@implementation NBRefreshAutoFooter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.nb_insetB += self.nb_h;
        }
        
        // 设置位置
        self.nb_y = _scrollView.nb_contentH;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.nb_insetB -= self.nb_h;
        }
    }
}

#pragma mark - 过期方法
- (void)setAppearencePercentTriggerAutoRefresh:(CGFloat)appearencePercentTriggerAutoRefresh
{
    self.triggerAutomaticallyRefreshPercent = appearencePercentTriggerAutoRefresh;
}

- (CGFloat)appearencePercentTriggerAutoRefresh
{
    return self.triggerAutomaticallyRefreshPercent;
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 默认底部控件100%出现时才会自动刷新
    self.triggerAutomaticallyRefreshPercent = 1.0;
    
    // 设置为默认状态
    self.automaticallyRefresh = YES;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 设置位置
    self.nb_y = self.scrollView.nb_contentH;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != NBRefreshStateIdle || !self.automaticallyRefresh || self.nb_y == 0) return;
    
    if (_scrollView.nb_insetT + _scrollView.nb_contentH > _scrollView.nb_h) { // 内容超过一个屏幕
        // 这里的_scrollView.nb_contentH替换掉self.nb_y更为合理
        if (_scrollView.nb_offsetY >= _scrollView.nb_contentH - _scrollView.nb_h + self.nb_h * self.triggerAutomaticallyRefreshPercent + _scrollView.nb_insetB - self.nb_h) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != NBRefreshStateIdle) return;
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.nb_insetT + _scrollView.nb_contentH <= _scrollView.nb_h) {  // 不够一个屏幕
            if (_scrollView.nb_offsetY >= - _scrollView.nb_insetT) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (_scrollView.nb_offsetY >= _scrollView.nb_contentH + _scrollView.nb_insetB - _scrollView.nb_h) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)setState:(NBRefreshState)state
{
    NBRefreshCheckState
    
    if (state == NBRefreshStateRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    } else if (state == NBRefreshStateNoMoreData || state == NBRefreshStateIdle) {
        if (NBRefreshStateRefreshing == oldState) {
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = NBRefreshStateIdle;
        
        self.scrollView.nb_insetB -= self.nb_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.nb_insetB += self.nb_h;
        
        // 设置位置
        self.nb_y = _scrollView.nb_contentH;
    }
}
@end
