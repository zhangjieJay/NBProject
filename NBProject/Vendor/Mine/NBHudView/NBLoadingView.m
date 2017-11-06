//
//  NBLoadingView.m
//  wenzhong
//
//  Created by 峥刘 on 17/5/12.
//  Copyright © 2017年 刘峥. All rights reserved.
//

#import "NBLoadingView.h"

@implementation NBLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect frame = CGRectMake((rect.size.width - 17.f)/2.f , (rect.size.width - 12.f)/2.f, 17.f, 12.f);
    [@"NB" drawInRect:frame withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10.f],NSForegroundColorAttributeName:[UIColor getColorNumber:0]}];
    CGContextDrawPath(context, kCGPathStroke);
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)startLoading{
    
    [self animateCircleRotation];
    [self setNeedsDisplay];
}
-(void)endLoading{

    for (CALayer * layer in self.layer.sublayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
    [self.layer removeAllAnimations];

}

@end
