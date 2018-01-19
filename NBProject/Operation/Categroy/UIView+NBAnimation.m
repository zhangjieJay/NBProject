//
//  UIView+NBAnimation.m
//  YJAutoProject
//
//  Created by 张杰 on 2017/4/29.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

/*
 ========fillMode======== 配合removedOnCompletion属性使用
 *
 kCAFillModeForwards                    当动画结束后,layer会一直保持着动画最后的状态
 kCAFillModeBackwards                   这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初                                         始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
 kCAFillModeBoth                        理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
 kCAFillModeRemoved                     这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
 */


/*
 ========timingFunction========
 *
 kCAMediaTimingFunctionLinear           动画一直匀速
 kCAMediaTimingFunctionEaseIn           淡入,缓慢加速进入，然后匀速
 kCAMediaTimingFunctionEaseOut          淡出,匀速，然后缓慢减速移除
 kCAMediaTimingFunctionEaseInEaseOut    淡入淡出，结合以上两者
 kCAMediaTimingFunctionDefault          默认效果
 */

//CFTimeInterval time = [layer convertTime:CACurrentMediaTime() fromLayer:nil];获取绝对时间

//speed 动画速度  动画时长 = drution / speed;
//timeOffset 动画开始时间点  如drution = 3s,  timeOffset = 2,则播放动画开始为第2-3s,然后跑剩余的 2秒从初始动画开始即动画时间节点 2-3(0)-1-2 总共还是跑了3s


#import "UIView+NBAnimation.h"





typedef NS_ENUM(NSInteger){
    NBAnimationType_FrameToSmall,
    NBAnimationType_FrameToLarge,
    NBAnimationType_
}NBAnimationType;


@implementation UIView (NBAnimation)


- (void)animateWithDuration:(NSTimeInterval)duration fromScale:(CGFloat)fScale toScale:(CGFloat)tScale{
    
    
    //    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //    animation.duration = duration;
    //    animation.fromValue = [NSNumber numberWithFloat:fScale];
    //    animation.toValue = [NSNumber numberWithFloat:tScale];
    //    [self.layer addAnimation:animation forKey:@"scaleAnimation"];
    
    
    
    //    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //    anima.fromValue = [NSNumber numberWithFloat:fScale];
    //    anima.toValue = [NSNumber numberWithFloat:tScale];
    //    anima.duration = duration;
    //    [self.layer addAnimation:anima forKey:@"opacityAniamtion"];
    
    
    CASpringAnimation * spriAnimation = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
    spriAnimation.fromValue = [NSNumber numberWithFloat:fScale];
    spriAnimation.toValue = [NSNumber numberWithFloat:tScale];
    
    spriAnimation.mass=1;//聚集;
    spriAnimation.initialVelocity = 0;
    
    spriAnimation.stiffness =500;//僵硬
    spriAnimation.damping =  10;//阻尼
    spriAnimation.duration = duration;
    [self.layer addAnimation:spriAnimation forKey:@"springAnimation"];
    
}

- (void)animateWithDuration:(NSTimeInterval)duration fromPositionX:(CGFloat)fpx toPositionX:(CGFloat)tpx{
    
    CABasicAnimation * baseAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    baseAnimation.fromValue = [NSNumber numberWithFloat:fpx];
    baseAnimation.toValue = [NSNumber numberWithFloat:tpx];
    baseAnimation.duration = duration;
    [self.layer addAnimation:baseAnimation forKey:@"positionXAnimation"];
    
    
    
}

- (void)animateWithDuration:(NSTimeInterval)duration fromPositionY:(CGFloat)fpy toPositionY:(CGFloat)tpy{
    CABasicAnimation * baseAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    baseAnimation.fromValue = [NSNumber numberWithFloat:fpy];
    baseAnimation.toValue = [NSNumber numberWithFloat:tpy];
    baseAnimation.duration = duration;
    baseAnimation.delegate = self.superview;
    [self.layer addAnimation:baseAnimation forKey:@"positionYAnimation"];
    
    
}


#pragma mark ------------------------------------ 自定义的动画  主要用于加载
- (void)animateCircleRotation{
    
    //创建与View大小相同的正方形
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor getColorNumber:10].CGColor; //圆环底色
    layer.frame = self.bounds;
    
    
    //设置圆环宽度及半径
    CGFloat NBLineWidth = 3.f;
    CGFloat NBWidth = MIN(self.bounds.size.width, self.bounds.size.height) ;
    CGFloat NBRadius = NBWidth/2.f;
    
    
    //颜色渐变的半个矩形
    NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)[UIColor getColorNumber:30].CGColor,(id)[UIColor getColorNumber:10].CGColor, nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, NBWidth/2.f, NBWidth, NBWidth/2.f);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    [layer addSublayer:gradientLayer]; //设置颜色渐变
    
    
    //创建路径1个圆
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(NBWidth/2.f, NBWidth/2.f) radius:NBRadius-NBLineWidth/2.f startAngle:0 endAngle:M_PI*2.f clockwise:YES];
    
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor getColorNumber:10].CGColor;
    shapeLayer.lineWidth = NBLineWidth;
    shapeLayer.path = circlePath.CGPath;
    layer.mask = shapeLayer;//设置遮罩,取layer与shapelayer的重叠部分
    
    
    //设置绕Z轴旋转的动画
    CABasicAnimation *rotationZ_Animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationZ_Animation.fromValue = [NSNumber numberWithFloat:0];
    rotationZ_Animation.toValue = [NSNumber numberWithFloat:6.0*M_PI];
    rotationZ_Animation.repeatCount = MAXFLOAT;
    rotationZ_Animation.duration = 4;
    [layer addAnimation:rotationZ_Animation forKey:@"rotation_z_animation"];

    [self.layer addSublayer:layer];
    
}


#pragma mark ------------------------------------ 带dash线的视图
- (void)animateDashCircleRotation
{
    CGFloat NBLineWidth = 3.f;
    CGFloat NBWidth = MIN(self.bounds.size.width, self.bounds.size.height) ;
    CGFloat NBRadius = NBWidth/2.f;
    
    //底部的灰色layer
    CAShapeLayer *bottomShapeLayer = [CAShapeLayer layer];
    bottomShapeLayer.strokeColor = [UIColor getColorNumber:10].CGColor;
    bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;
    bottomShapeLayer.lineWidth = NBLineWidth;
    bottomShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:NBRadius-NBLineWidth/2.f].CGPath;
    [self.layer addSublayer:bottomShapeLayer];
    
    //橘黄色的layer
    CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
    ovalShapeLayer.strokeColor = [UIColor getColorNumber:125].CGColor;
    ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ovalShapeLayer.lineWidth = NBLineWidth;
    ovalShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:NBRadius-NBLineWidth/2.f].CGPath;
    ovalShapeLayer.lineDashPattern = @[@6,@3];
    
    
    //起点动画
    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1);
    
    
    //终点动画
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0);
    strokeEndAnimation.toValue = @(1.0);
    
    
    /// 组合动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeStartAnimation,strokeEndAnimation];
    animationGroup.duration = 1.5f;
    animationGroup.repeatCount = CGFLOAT_MAX;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [ovalShapeLayer addAnimation:animationGroup forKey:nil];
    [self.layer addSublayer:ovalShapeLayer];

}

-(void)throwToView:(UIView *)target{
    
    CGPoint point_origin = [self.superview convertPoint:self.center toView:NB_KEYWINDOW];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:point_origin];
    //确定抛物线的最高点位置  controlPoint
    CGPoint point_max = CGPointMake(point_origin.x+50,point_origin.y-50);
    CGPoint point_finish = [target.superview convertPoint:target.center toView:NB_KEYWINDOW];
    [path addQuadCurveToPoint:point_max controlPoint:point_finish];
    [path addLineToPoint:point_max];
    
    //关键帧动画

    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path.CGPath;
    pathAnimation.duration = 1.2;

    
    //往下抛时旋转小动画
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:2* M_PI];
    rotateAnimation.duration = 0.75;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.fillMode = kCAFillModeBackwards;
    rotateAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    
    

    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[pathAnimation,rotateAnimation];
    groups.duration = 1.2f;
    
    //设置之后做动画的layer不会回到一开始的位置
    groups.removedOnCompletion = YES;

    groups.fillMode=kCAFillModeRemoved;
//    CALayer * layer = [CALayer layer];
//    layer.contents = [self shot];
//    [layer addAnimation:rotateAnimation forKey:@"group"];
//    [self.layer addSublayer:layer];
    [self.layer addAnimation:pathAnimation forKey:@"group"];


}



#pragma mark ------------------------------------ 暂停动画
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed=0.0; // 让CALayer的时间停止走动
    layer.timeOffset=pausedTime; // 让CALayer的时间停留在pausedTime这个时刻
}
#pragma mark ------------------------------------ 恢复动画
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime =layer.timeOffset;
    layer.speed=1.0; // 让CALayer的时间继续行走
    layer.timeOffset=0.0; // 取消上次记录的停留时刻
    layer.beginTime=0.0; // 取消上次设置的时间
    
    //计算暂停的时间(这里用CACurrentMediaTime()-pausedTime也是一样的)
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    //设置相对于父坐标系的开始时间(往后退timeSincePause)
    layer.beginTime = timeSincePause;
}



@end
