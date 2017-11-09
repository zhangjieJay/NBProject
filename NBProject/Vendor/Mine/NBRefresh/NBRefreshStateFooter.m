//
//  NBRefreshStateFooter.m
//  NBProject
//
//  Created by JayZhang on 2017/11/7.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRefreshStateFooter.h"
#import "NSBundle+NBRefresh.h"
@interface NBRefreshStateFooter()
{

    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation NBRefreshStateFooter
#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel nb_label]];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(NBRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 私有方法
- (void)stateLabelClick
{
    if (self.state == NBRefreshStateIdle) {
        [self beginRefreshing];
    }
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = NBRefreshLabelLeftInset;
    
    // 初始化文字
    [self setTitle:[NSBundle nb_localizedStringForKey:NBRefreshAutoFooterIdleText] forState:NBRefreshStateIdle];
    [self setTitle:[NSBundle nb_localizedStringForKey:NBRefreshAutoFooterRefreshingText] forState:NBRefreshStateRefreshing];
    [self setTitle:[NSBundle nb_localizedStringForKey:NBRefreshAutoFooterNoMoreDataText] forState:NBRefreshStateNoMoreData];
    
    // 监听label
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(NBRefreshState)state
{
    NBRefreshCheckState
    
    if (self.isRefreshingTitleHidden && state == NBRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}
@end
