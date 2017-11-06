//
//  UIView+NBAnimation.m
//  YJAutoProject
//
//  Created by 张杰 on 2017/4/29.
//  Copyright © 2017年 JayZhang. All rights reserved.
//

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




@end
