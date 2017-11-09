//
//  NBRefreshNormalHeader.m
//  NBProject
//
//  Created by JayZhang on 2017/11/7.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRefreshNormalHeader.h"
#import "NSBundle+NBRefresh.h"
#import "NBLoadingView.h"
#import "UIColor+NBCategory.h"


@interface NBRefreshNormalHeader()

@property(strong,nonatomic)NBLoadingView * loadingView;

@end

@implementation NBRefreshNormalHeader
#pragma mark - 懒加载子控件


- (NBLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[NBLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.nb_h/2.f, self.nb_h/2.f)];
        _loadingView.backgroundColor =  [UIColor getColorNumber:-1];
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat loadingCenterX = self.nb_w * 0.5;
    if (!self.stateLabel.hidden) {
        CGFloat stateWidth = self.stateLabel.nb_textWith;
        CGFloat timeWidth = 0.0;
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeWidth = self.lastUpdatedTimeLabel.nb_textWith;
        }
        CGFloat textWidth = MAX(stateWidth, timeWidth);
        loadingCenterX -= textWidth / 2 + self.labelLeftInset;
    }
    CGFloat loadingCenterY = self.nb_h * 0.5;
    CGPoint loadingCenter = CGPointMake(loadingCenterX, loadingCenterY);
    
    
    // 加载圆圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = loadingCenter;
    }
    
    self.loadingView.tintColor = self.stateLabel.textColor;
}


- (void)setState:(NBRefreshState)state
{
    NBRefreshCheckState
    
    // 根据状态做事情
    if (state == NBRefreshStateIdle) {
        [self.loadingView endLoading];
        if (oldState == NBRefreshStateRefreshing) {
            
            [UIView animateWithDuration:NBRefreshSlowAnimationDuration animations:^{
                
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != NBRefreshStateIdle) return;
                
            }];
        } else {
            [UIView animateWithDuration:NBRefreshFastAnimationDuration animations:^{
                
            }];
        }
    } else if (state == NBRefreshStatePulling) {
        
        [UIView animateWithDuration:NBRefreshFastAnimationDuration animations:^{
            
        }];
    } else if (state == NBRefreshStateRefreshing) {
        
        [self.loadingView startLoading];
    }
}
@end
