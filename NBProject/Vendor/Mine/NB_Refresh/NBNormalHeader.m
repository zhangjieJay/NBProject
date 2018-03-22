//
//  NBNormalHeader.m
//  NBProject
//
//  Created by 张杰 on 2018/1/25.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBNormalHeader.h"

@interface NBNormalHeader(){
    
    __unsafe_unretained UIActivityIndicatorView * _loadingView;

}

@end

@implementation NBNormalHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)initBaseControls{
    
    
    [super initBaseControls];
    
    if (self.loadingView.constraints.count) return;
    // 菊花的中心点
    CGFloat indicatorCenterX = self.nb_w * 0.5;
    CGFloat indicatorCenterY = self.nb_h * 0.5;
    CGPoint indicatorCenter = CGPointMake(indicatorCenterX, indicatorCenterY);
    self.loadingView.center = indicatorCenter;
    self.loadingView.contentMode = UIViewContentModeCenter;

}

-(void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
//    [self overlayMaskWithPercent:self.pullingPercent];
}

-(void)setState:(NBRefreshState)state{
    NBCheckState
    if (self.state == NBRefreshStateIdle) {
        
        [self.loadingView stopAnimating];
    }
    else if (self.state == NBRefreshStatePulling){
        
        [self.loadingView stopAnimating];

    }
    else if (self.state == NBRefreshStateRefreshing){
        
        [self.loadingView startAnimating];

    }
}

-(UIActivityIndicatorView *)loadingView{
    
    if (!_loadingView) {
        UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.hidesWhenStopped = NO;
        indicator.color = [UIColor getColorNumber:500];
        _loadingView = indicator;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

-(void)overlayMaskWithPercent:(CGFloat)percent{
    
    if (percent >= 1.f) {
        percent = 1.f;
        self.loadingView.layer.mask = nil;
        
    }else{
        //中间透明矩形作用区域
        CGFloat ratio = self.loadingView.nb_h/2.f;//
        
        CGFloat y_now = percent * self.nb_h;
        CGFloat start = self.loadingView.nb_centerY;

        CGFloat indePercent =(y_now - start)/(self.nb_h - start);
        
        if (indePercent>=0 && indePercent<=1) {
            self.loadingView.hidden = NO;

            CGFloat angle = indePercent *2 * M_PI;
            NSLog(@"当前百分百:%lf",indePercent);
            CGPoint center = CGPointMake(ratio, ratio);
            UIGraphicsBeginImageContext(self.loadingView.bounds.size);
            
            UIBezierPath * path = [UIBezierPath bezierPath];
            [path moveToPoint:center];
            [path addArcWithCenter:center radius:ratio startAngle:0 endAngle:angle clockwise:YES];
            path.lineWidth = 1.f;
            
            
            
            CAShapeLayer * shape = [CAShapeLayer layer];
            shape.path = path.CGPath;
            
            self.loadingView.layer.mask = shape;
            UIGraphicsEndImageContext();
            
        }else{
            self.loadingView.layer.mask = nil;

        }
 
    }
  
}

@end
