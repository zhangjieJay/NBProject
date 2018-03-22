//
//  NBRefreshComponent.m
//  NBProject
//
//  Created by 张杰 on 2018/1/23.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBRefreshComponent.h"

@interface NBRefreshComponent()

@end

@implementation NBRefreshComponent

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 准备工作
        [self prepare];
        
        // 默认是普通状态
        self.state = NBRefreshStateIdle;
    }
    return self;
}
-(void)dealloc{
    NSLog(@"%@被释放",NSStringFromClass([self class]));
}
-(void)layoutSubviews{
    [self initBaseControls];
    [super layoutSubviews];
}

-(void)initBaseControls{};

-(void)prepare{
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    self.automaticallyChangeAlpha = NO;
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    // 旧的父控件移除监听
    
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 设置宽度
        self.nb_w = newSuperview.nb_w;
        // 设置位置
        self.nb_x = -_scrollView.nb_insetL;
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.nb_inset;
        // 添加监听
        [self addObservers];
    }

}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.state == NBRefreshStateWillRefresh) {
        // 预防view还没显示出来就调用了beginRefreshing
        self.state = NBRefreshStateRefreshing;
    }
}


- (void)removeObservers{
    [self.superview removeObserver:self forKeyPath:NBRefreshKeyPathContentOffset];
}
#pragma mark ------------------------------------ 添加KVO监听
- (void)addObservers{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:NBRefreshKeyPathContentOffset options:options context:nil];

}

#pragma mark ------------------------------------ KVO监听触发
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    /*不能交互直接返回*/
    if (self.userInteractionEnabled == NO) {
        return;
    }
    // 这个就算看不见也需要处理
    if ([keyPath isEqualToString:NBRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}
#pragma mark ------------------------------------ 开始刷新
-(void)beginRefreshing{
    [UIView animateWithDuration:NBRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    self.pullingPercent = 1.0;
    // 只要正在刷新，就完全显示
    if (self.window) {
        self.state = NBRefreshStateRefreshing;
    } else {
        // 预防正在刷新中时，调用本方法使得header inset回置失败
        if (self.state != NBRefreshStateRefreshing) {
            self.state = NBRefreshStateWillRefresh;
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            [self setNeedsDisplay];
        }
    }
}
#pragma mark ------------------------------------ 结束刷新状态
- (void)endRefreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = NBRefreshStateIdle;
    });
}
-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)setState:(NBRefreshState)state
{
    _state = state;
    NSLog(@"当前状态%ld",state);
    // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

#pragma mark ------------------------------------ 内部方法
- (void)executeRefreshingCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
    });
}
#pragma mark ------------------------------------ 自动切换透明度
- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha
{
    _automaticallyChangeAlpha = automaticallyChangeAlpha;
    
    if (self.isRefreshing) return;
    
    if (automaticallyChangeAlpha) {
        self.alpha = self.pullingPercent;
    } else {
        self.alpha = 1.0;
    }
}

#pragma mark ------------------------------------ 是否正在刷新
- (BOOL)isRefreshing
{
    return self.state == NBRefreshStateRefreshing || self.state == NBRefreshStateWillRefresh;
}

#pragma mark ------------------------------------ 根据拖拽进度设置透明度
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    _pullingPercent = pullingPercent;
    
    if (self.isRefreshing) return;
    
    if (self.isAutomaticallyChangeAlpha) {
        self.alpha = pullingPercent;
    }
}
@end




#pragma mark ------------------------------------ UILabel 
@implementation UILabel(NBRefresh)
+ (instancetype)nb_label
{
    UILabel *label = [[self alloc] init];
    label.font = NBRefreshLabelFont;
    label.textColor = NBRefreshLabelTextColor;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)nb_textWith {
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.text.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringWidth =[self.text
                      boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:self.font}
                      context:nil].size.width;
#else
        
        stringWidth = [self.text sizeWithFont:self.font
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByCharWrapping].width;
#endif
    }
    return stringWidth;
}
@end
