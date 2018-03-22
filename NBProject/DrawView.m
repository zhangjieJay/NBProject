//
//  DrawView.m
//  NBProject
//
//  Created by 张杰 on 2018/1/22.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "DrawView.h"
@interface DrawView()

@property(nonatomic,strong)BaseView * viewTest;
@property(nonatomic,strong)BaseView * viewCar;
@end
@implementation DrawView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGFloat ratio = rect.size.width/2.f;//
    CGPoint center = CGPointMake(ratio, ratio);
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:ratio startAngle:0 endAngle:2*M_PI clockwise:YES];
    path.lineWidth = 1.f;
    
    
    CAShapeLayer * shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    
    self.layer.mask = shape;

//    [self dosomething];
}


-(void)dosomething{
    
    [self.viewTest throwToView:self.viewCar];

}
-(BaseView *)viewTest{
    
    if (!_viewTest) {
        _viewTest = [[BaseView alloc]initWithFrame:CGRectMake(0, 100, 20, 20)];
        _viewTest.backgroundColor = [UIColor redColor];
        [self addSubview:_viewTest];
    }
    return _viewTest;
}

-(BaseView *)viewCar{
    
    if (!_viewCar ) {
        _viewCar = [[BaseView alloc]initWithFrame:CGRectMake(300, 500, 50, 50)];
        _viewCar.backgroundColor = [UIColor blueColor];
        [self addSubview:_viewCar];
    }
    return _viewCar;
}


@end
