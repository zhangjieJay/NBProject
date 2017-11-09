//
//  NBRefreshAutoNormalFooter.m
//  NBProject
//
//  Created by JayZhang on 2017/11/7.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRefreshAutoNormalFooter.h"
#import "NBLoadingView.h"
#import "UIColor+NBCategory.h"


@interface NBRefreshAutoNormalFooter()
@property(strong,nonatomic)NBLoadingView * loadingView;
@end

@implementation NBRefreshAutoNormalFooter
#pragma mark - 懒加载子控件
- (NBLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[NBLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.nb_h/2.f, self.nb_h/2.f)];
        _loadingView.backgroundColor =  [UIColor getColorNumber:-1];
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}
#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count) return;
    
    // 圈圈
    CGFloat loadingCenterX = self.nb_w * 0.5;
    if (!self.isRefreshingTitleHidden) {
        loadingCenterX -= self.stateLabel.nb_textWith * 0.5 + self.labelLeftInset;
    }
    CGFloat loadingCenterY = self.nb_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
}

- (void)setState:(NBRefreshState)state
{
    NBRefreshCheckState
    
    // 根据状态做事情
    if (state == NBRefreshStateNoMoreData || state == NBRefreshStateIdle) {
        self.loadingView.hidden = YES;
        [self.loadingView endLoading];
        
    } else if (state == NBRefreshStateRefreshing) {
        self.loadingView.hidden = NO;
        [self.loadingView startLoading];
    }
}

@end
