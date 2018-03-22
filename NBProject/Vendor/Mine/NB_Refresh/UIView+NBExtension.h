//
//  UIView+NBExtension.h
//  NBProject
//
//  Created by JayZhang on 2017/11/6.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NBExtension)

@property (assign, nonatomic) CGFloat nb_x;
@property (assign, nonatomic) CGFloat nb_y;
@property (assign, nonatomic) CGFloat nb_w;
@property (assign, nonatomic) CGFloat nb_h;
@property (assign, nonatomic,readonly) CGFloat nb_b;
@property (assign, nonatomic,readonly) CGFloat nb_r;
@property (assign, nonatomic,readonly) CGFloat nb_centerY;
@property (assign, nonatomic,readonly) CGFloat nb_centerX;



@property (assign, nonatomic) CGSize nb_size;
@property (assign, nonatomic) CGPoint nb_origin;

@end
