//
//  UIView+NBExtension.m
//  NBProject
//
//  Created by JayZhang on 2017/11/6.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "UIView+NBExtension.h"

@implementation UIView (NBExtension)
- (void)setNb_x:(CGFloat)nb_x
{
    CGRect frame = self.frame;
    frame.origin.x = nb_x;
    self.frame = frame;
}

- (CGFloat)nb_x
{
    return self.frame.origin.x;
}

- (void)setNb_y:(CGFloat)nb_y
{
    CGRect frame = self.frame;
    frame.origin.y = nb_y;
    self.frame = frame;
}

- (CGFloat)nb_y
{
    return self.frame.origin.y;
}

- (void)setNb_w:(CGFloat)nb_w
{
    CGRect frame = self.frame;
    frame.size.width = nb_w;
    self.frame = frame;
}

- (CGFloat)nb_w
{
    return self.frame.size.width;
}

- (void)setNb_h:(CGFloat)nb_h
{
    CGRect frame = self.frame;
    frame.size.height = nb_h;
    self.frame = frame;
}

- (CGFloat)nb_h
{
    return self.frame.size.height;
}

- (void)setNb_size:(CGSize)nb_size
{
    CGRect frame = self.frame;
    frame.size = nb_size;
    self.frame = frame;
}

- (CGSize)nb_size
{
    return self.frame.size;
}

- (void)setNb_origin:(CGPoint)nb_origin
{
    CGRect frame = self.frame;
    frame.origin = nb_origin;
    self.frame = frame;
}

- (CGPoint)nb_origin
{
    return self.frame.origin;
}
@end
