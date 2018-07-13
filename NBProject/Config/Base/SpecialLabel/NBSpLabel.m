//
//  NBSpLabel.m
//  NBProject
//
//  Created by 张杰 on 2018/5/29.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBSpLabel.h"

@implementation NBSpLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
#pragma mark ------------------------------------ 设置文字描边
- (void)drawRect:(CGRect)rect {
     //Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    // 设置描边宽度
    CGContextSetLineWidth(c, 1);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    // 描边颜色
    self.textColor = [UIColor redColor];
    [super drawTextInRect:rect];
    // 文本颜色
    self.textColor = [UIColor yellowColor];
    CGContextSetTextDrawingMode(c, kCGTextFill);
    [super drawTextInRect:rect];
    
}

- (void)drawTextInRect:(CGRect)rect {
    // 边距，上左下右
    if (!UIEdgeInsetsEqualToEdgeInsets(self.inset, UIEdgeInsetsZero) ) {
        [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.inset)];
    }else{
        [super drawTextInRect:rect];
    }
}


@end
