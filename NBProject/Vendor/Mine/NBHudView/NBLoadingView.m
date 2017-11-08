//
//  NBLoadingView.m
//  wenzhong
//
//  Created by 峥刘 on 17/5/12.
//  Copyright © 2017年 刘峥. All rights reserved.
//

#import "NBLoadingView.h"

@interface NBLoadingView()


@end

@implementation NBLoadingView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    //字体
    UIFont  *font = [UIFont boldSystemFontOfSize:10];
    
    //构建属性集合
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:[UIColor getColorNumber:30]};
    //获得size
    NSString * centerString = @"NB";
    CGSize strSize = [centerString sizeWithAttributes:attributes];
    CGFloat marginTop = (rect.size.height - strSize.height)/2;
    //垂直居中要自己计算
    CGRect rectText = CGRectMake((rect.size.width-strSize.width)/2.f, marginTop,strSize.width, strSize.height);
    
    [centerString drawInRect:rectText withAttributes:attributes];
    CGContextDrawPath(context, kCGPathStroke);
    
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mainColor = [UIColor getColorNumber:30];
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
    [self setNeedsDisplay];

}



@end
