//
//  NBCircleHeader.m
//  NBProject
//
//  Created by 张杰 on 2018/1/25.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBCircleHeader.h"

@interface NBCircleHeader(){
    
    __unsafe_unretained UIView * _circleView;

}
@end

@implementation NBCircleHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)initBaseControls{
    [super initBaseControls];
    if (self.circleView.constraints.count) return;
    self.nb_h = 40;
    self.circleView.nb_size = CGSizeMake(20, 20);
    CGFloat indicatorCenterX = self.nb_w * 0.5;
    CGFloat indicatorCenterY = self.nb_h * 0.5;
    CGPoint indicatorCenter = CGPointMake(indicatorCenterX, indicatorCenterY);
    self.circleView.center = indicatorCenter;
}
-(void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
    
}
-(void)setState:(NBRefreshState)state{
        NBCheckState;
    if (state == NBRefreshStateIdle) {
        [self stopLoading];
    }
    else if (state == NBRefreshStateRefreshing){
        [self startLoading];
    }
}

-(void)startLoading{
    
    self.circleView.layer.mask = nil;
    
    //创建与View大小相同的正方形
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor getColorNumber:10].CGColor; //圆环底色
    layer.frame = self.circleView.bounds;
    layer.name = @"animationlayer";
    
    //设置圆环宽度及半径
    CGFloat NBLineWidth = 3.f;
    CGFloat NBWidth = self.circleView.nb_w;
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
    
    [self.circleView.layer addSublayer:layer];
    
}

-(void)stopLoading{
    
    for (CALayer * layer in self.circleView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

#pragma mark ------------------------------------ 防止离屏动画停止
-(void)didMoveToWindow{
//    if (self.window) {
//        if (self.state == NBRefreshStateRefreshing) {
//            [self startLoading];
//        }
//    }else{
//        [self stopLoading];
//    }
}

-(void)pullingWithPercent:(CGFloat)percent{
    
    if (self.state != NBRefreshStateRefreshing) {
        
        CGFloat y_now = percent * self.nb_h;
        CGFloat start = self.circleView.nb_b;
        
        CGFloat indePercent =(y_now - start)/(self.nb_h - start);
        
        if (indePercent>=0 && indePercent<=1) {
        
        CGFloat ratio = self.circleView.nb_w/2.f;
        CGFloat angle = percent * 2 * M_PI;
        CGPoint center = CGPointMake(ratio, ratio);
        UIGraphicsBeginImageContext(self.circleView.nb_size);
        CGFloat NBLineWidth = 3.f;
        
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:(ratio-NBLineWidth/2.f) startAngle:0 endAngle:angle clockwise:YES];
        path.lineWidth = NBLineWidth;
        CAShapeLayer * shape = [CAShapeLayer layer];
        shape.path = path.CGPath;
        self.circleView.layer.mask = shape;
        UIGraphicsEndImageContext();
        }
    }
}



-(UIView *)circleView{
    
    if (!_circleView) {
        UIView * cirView = [[UIView alloc]init];
        _circleView = cirView;
        [self addSubview:_circleView];
    }
    return _circleView;
}

@end
