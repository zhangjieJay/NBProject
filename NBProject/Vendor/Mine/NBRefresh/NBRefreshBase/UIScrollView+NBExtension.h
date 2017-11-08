//
//  UIScrollView+NBExtension.h
//  NBProject
//
//  Created by scuser on 2017/11/6.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (NBExtension)
@property (readonly, nonatomic) UIEdgeInsets nb_inset;

@property (assign, nonatomic) CGFloat nb_insetT;
@property (assign, nonatomic) CGFloat nb_insetB;
@property (assign, nonatomic) CGFloat nb_insetL;
@property (assign, nonatomic) CGFloat nb_insetR;

@property (assign, nonatomic) CGFloat nb_offsetX;
@property (assign, nonatomic) CGFloat nb_offsetY;

@property (assign, nonatomic) CGFloat nb_contentW;
@property (assign, nonatomic) CGFloat nb_contentH;
@end
