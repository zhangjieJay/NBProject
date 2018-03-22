//
//  NBGifHeader.m
//  NBProject
//
//  Created by 张杰 on 2018/1/24.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBGifHeader.h"

@interface NBGifHeader()
{
    __unsafe_unretained UIImageView *_gifView;
}
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation NBGifHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark ------------------------------------ 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    NSMutableArray *refreshingImgs = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"gif1"] ]];
    for (int i = 1; i<17; i++) {
        UIImage * image =[UIImage imageNamed:[NSString stringWithFormat:@"gif%d",i]];
        if (image) {
            [refreshingImgs addObject:image];
        }
    }
    [self setImages:refreshingImgs duration:0.8 forState:NBRefreshStateRefreshing];
    [self setImages:@[[UIImage imageNamed:@"gif1"]] forState:NBRefreshStateIdle];
}

#pragma mark ------------------------------------ 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(NBRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.nb_h) {
        self.nb_h = image.size.height;
    }
}
- (void)setImages:(NSArray *)images forState:(NBRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(NBRefreshStateIdle)];
    if (self.state != NBRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.gifView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}
- (void)setState:(NBRefreshState)state
{
    NBCheckState
    
    // 根据状态做事情
    if (state == NBRefreshStatePulling || state == NBRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
            [self.gifView startAnimating];
        }
    } else if (state == NBRefreshStateIdle) {
        [self.gifView stopAnimating];
    }
}





-(void)initBaseControls{
    
    [super initBaseControls];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    self.gifView.contentMode = UIViewContentModeCenter;

}




#pragma mark ------------------------------------ 懒加载

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}
- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        _gifView = gifView;
        [self addSubview:_gifView];
    }
    return _gifView;
}

@end
